import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/env.dart';
import '../../../../core/utils/purchases_safe_call.dart';
import '../../../../core/services/models/plant_tree_request.dart';
import '../../../../core/services/models/plant_tree_response.dart';
import '../../../../core/services/models/tree_nation_exception.dart';
import '../../../../core/services/tree_nation_service.dart';
import '../../domain/entities/planted_tree_entity.dart';
import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/repositories/tree_garden_repository.dart';

/// Implementação concreta do [TreeGardenRepository].
///
/// Guarda o progresso em uma única linha (id fixo 1) na tabela [TreeProgress]
/// do Drift. Cada anúncio assistido (início/fim de corrida, banner) credita a
/// receita real que pagou (ou uma estimativa, se a conta AdMob ainda não
/// reporta receita por impressão); ao acumular [treePriceUsd], uma árvore de
/// verdade é plantada via [TreeNationService].
class TreeGardenRepositoryImpl implements TreeGardenRepository {
  /// Preço da árvore lido do `.env`. `tryParse` em vez de `parse` porque um
  /// valor ausente/vazio/malformado estouraria uma `FormatException` no
  /// inicializador estático, derrubando todo o fluxo de crédito de anúncio.
  static double treePriceUsd = _readTreePriceUsd();

  /// Espécie usada no plantio. Opcional: quando ausente, a Tree-Nation usa o
  /// "tree template" ligado ao token. Se a conta não tiver template
  /// configurado, a API responde `tree_template / no tree template` — nesse
  /// caso defina `TREE_NATION_SPECIES_ID` no `.env` com o id de uma espécie
  /// com `stock > 0` (`GET /api/projects/{id}/species`).
  static int? get speciesId => int.tryParse(envOrNull('TREE_NATION_SPECIES_ID') ?? '');

  static double _readTreePriceUsd() {
    final raw = envOrNull('TREE_PRICE');
    final parsed = double.tryParse(raw ?? '');
    if (parsed == null || parsed <= 0) {
      debugPrint('[Garden] TREE_PRICE inválido no .env: "${raw ?? '<ausente>'}"');
      return 0;
    }
    return parsed;
  }

  static const int _rowId = 1;

  final AppDatabase _db;
  final TreeNationService _treeNationService;

  TreeGardenRepositoryImpl({AppDatabase? db, TreeNationService? treeNationService})
    : _db = db ?? AppDatabase.instance,
      _treeNationService = treeNationService ?? TreeNationService();

  @override
  Future<TreeProgressEntity> getProgress() async {
    final row = await _getOrCreateRow();
    final entity = _toEntity(row);
    debugPrint(
      '[Garden] getProgress: saldo \$${entity.revenueAccumulatedUsd} | '
      'preço \$${entity.treePriceUsd} | árvores ${entity.treesPlanted} | '
      '${(entity.progressPercent * 100).toStringAsFixed(1)}%',
    );
    return entity;
  }

  @override
  Future<TreeProgressEntity> creditAdRevenueAndUpdateProgress(double revenueUsd) async {
    final row = await _getOrCreateRow();
    var revenue = row.revenueAccumulatedUsd + revenueUsd;
    var trees = row.treesPlanted;

    debugPrint(
      '[Garden] crédito de anúncio: +\$$revenueUsd | '
      'acumulado ${row.revenueAccumulatedUsd} -> $revenue | '
      'preço da árvore \$$treePriceUsd | árvores $trees',
    );

    // Preço inválido (TREE_PRICE ausente/zerado no .env) tornaria o `while`
    // abaixo um laço infinito e zeraria o progresso exibido. Aborta cedo e
    // deixa o motivo explícito no log.
    if (treePriceUsd <= 0) {
      debugPrint(
        '[Garden] ERRO: TREE_PRICE inválido ($treePriceUsd). '
        'Defina TREE_PRICE no .env — nenhuma árvore será plantada.',
      );
      await _persist(revenue, trees);
      return TreeProgressEntity(
        revenueAccumulatedUsd: revenue,
        treePriceUsd: treePriceUsd,
        treesPlanted: trees,
      );
    }

    // Identifica o plantio com o appUserID da RevenueCat, ligando o registro
    // real da Tree-Nation ao mesmo usuário rastreado nos eventos de anúncio.
    // Sem RevenueCat configurado, planta sem esse vínculo em vez de falhar.
    final planterId = await safePurchasesCall('appUserID', () => Purchases.appUserID);
    debugPrint('[Garden] planterId=${planterId ?? "<null: RevenueCat off>"}');

    if (revenue < treePriceUsd) {
      debugPrint(
        '[Garden] ainda não dá para plantar: faltam '
        '\$${(treePriceUsd - revenue).toStringAsFixed(4)}',
      );
    }

    while (revenue >= treePriceUsd) {
      debugPrint('[Garden] tentando plantar árvore (saldo \$$revenue)...');
      try {
        final response = await _treeNationService.plantTree(
          PlantTreeRequest(
            quantity: 1,
            planterId: planterId,
            speciesId: speciesId,
          ),
        );
        await _savePlantedTrees(response);
        revenue -= treePriceUsd;
        trees += 1;
        debugPrint(
          '[Garden] árvore plantada! total=$trees | saldo restante \$$revenue',
        );
      } on TreeNationException catch (e) {
        // Erro de negócio da API. Se for de configuração da conta (sem tree
        // template, sem crédito, token inválido), repetir não resolve — o
        // ajuste é no painel da Tree-Nation.
        debugPrint('[Garden] FALHA ao plantar: $e');
        if (e.isAccountConfigError) {
          debugPrint(
            '[Garden] erro de CONFIGURAÇÃO da conta Tree-Nation — nenhuma '
            'tentativa futura vai funcionar até ser corrigido no painel.',
          );
        }
        _logStuckAtFullRing(revenue);
        break;
      } catch (e, st) {
        // Falha ao plantar de verdade (rede/API indisponível): mantém a
        // receita acumulada para tentar novamente na próxima vez. Enquanto
        // isso o progresso fica travado em 100%, porque `revenue` continua
        // >= treePriceUsd — é esse o sintoma visível do anel cheio.
        debugPrint('[Garden] FALHA ao plantar: $e');
        debugPrint('[Garden] stack: $st');
        _logStuckAtFullRing(revenue);
        break;
      }
    }

    await _persist(revenue, trees);

    // Expõe o progresso no perfil do usuário na RevenueCat (visível no
    // dashboard e disponível para segmentação/CRM), sem exigir assinatura.
    // Best-effort: não deve bloquear o progresso local se falhar.
    fireAndForgetPurchasesCall(
      'setAttributes',
      () => Purchases.setAttributes({
        'ad_revenue_accumulated_usd': revenue.toStringAsFixed(4),
        'trees_planted': '$trees',
      }),
    );

    final result = TreeProgressEntity(
      revenueAccumulatedUsd: revenue,
      treePriceUsd: treePriceUsd,
      treesPlanted: trees,
    );
    debugPrint(
      '[Garden] progresso final: ${(result.progressPercent * 100).toStringAsFixed(1)}% '
      '(${result.seedsAccumulated}/${TreeProgressEntity.seedsPerTree} sementes) | '
      'árvores=${result.treesPlanted}',
    );
    return result;
  }

  void _logStuckAtFullRing(double revenue) => debugPrint(
    '[Garden] progresso travado em 100%: saldo \$$revenue >= '
    'preço \$$treePriceUsd e a árvore não foi criada.',
  );

  Future<void> _persist(double revenue, int trees) => _db
      .into(_db.treeProgress)
      .insertOnConflictUpdate(
        TreeProgressCompanion(
          id: const Value(_rowId),
          revenueAccumulatedUsd: Value(revenue),
          treesPlanted: Value(trees),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<TreeProgressData> _getOrCreateRow() async {
    final existing = await (_db.select(
      _db.treeProgress,
    )..where((t) => t.id.equals(_rowId))).getSingleOrNull();
    if (existing != null) return existing;

    await _db
        .into(_db.treeProgress)
        .insertOnConflictUpdate(const TreeProgressCompanion(id: Value(_rowId)));
    return (_db.select(
      _db.treeProgress,
    )..where((t) => t.id.equals(_rowId))).getSingle();
  }

  TreeProgressEntity _toEntity(TreeProgressData row) => TreeProgressEntity(
    revenueAccumulatedUsd: row.revenueAccumulatedUsd,
    treePriceUsd: treePriceUsd,
    treesPlanted: row.treesPlanted,
  );

  /// Persiste cada árvore de [response.trees] na "floresta" local — usado
  /// para exibir o grid de árvores e o CO2 total compensado na GardenPage.
  Future<void> _savePlantedTrees(PlantTreeResponse response) async {
    debugPrint('[Garden] salvando ${response.trees.length} árvore(s) no SQLite');
    for (final tree in response.trees) {
      await _db
          .into(_db.plantedTrees)
          .insert(
            PlantedTreesCompanion.insert(
              treeNationId: tree.id,
              token: tree.token,
              collectUrl: tree.collectUrl,
              certificateUrl: tree.certificateUrl,
              country: tree.country,
              projectId: tree.projectId,
              projectName: tree.projectName,
              projectUrl: tree.projectUrl,
              speciesId: tree.speciesId,
              speciesName: tree.speciesName,
              speciesLifeTimeCo2: Value(tree.speciesLifeTimeCo2),
              paymentId: Value(response.paymentId),
            ),
          );
    }
  }

  @override
  Future<List<PlantedTreeEntity>> getPlantedTrees() async {
    final rows =
        await (_db.select(_db.plantedTrees)
              ..orderBy([(t) => OrderingTerm.desc(t.plantedAt)]))
            .get();

    return rows
        .map(
          (row) => PlantedTreeEntity(
            treeNationId: row.treeNationId,
            certificateUrl: row.certificateUrl,
            collectUrl: row.collectUrl,
            country: row.country,
            projectName: row.projectName,
            projectUrl: row.projectUrl,
            speciesName: row.speciesName,
            co2LifeTimeKg: row.speciesLifeTimeCo2,
            plantedAt: row.plantedAt,
          ),
        )
        .toList();
  }
}
