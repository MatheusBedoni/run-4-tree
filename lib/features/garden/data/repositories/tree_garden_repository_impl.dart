import 'package:drift/drift.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/purchases_safe_call.dart';
import '../../../../core/services/models/plant_tree_request.dart';
import '../../../../core/services/tree_nation_service.dart';
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
  static double treePriceUsd = double.parse(dotenv.env['TREE_PRICE'] ?? '0');
  static const int _rowId = 1;

  final AppDatabase _db;
  final TreeNationService _treeNationService;

  TreeGardenRepositoryImpl({AppDatabase? db, TreeNationService? treeNationService})
    : _db = db ?? AppDatabase.instance,
      _treeNationService = treeNationService ?? TreeNationService();

  @override
  Future<TreeProgressEntity> getProgress() async {
    final row = await _getOrCreateRow();
    return _toEntity(row);
  }

  @override
  Future<TreeProgressEntity> creditAdRevenueAndUpdateProgress(double revenueUsd) async {
    final row = await _getOrCreateRow();
    var revenue = row.revenueAccumulatedUsd + revenueUsd;
    var trees = row.treesPlanted;

    // Identifica o plantio com o appUserID da RevenueCat, ligando o registro
    // real da Tree-Nation ao mesmo usuário rastreado nos eventos de anúncio.
    // Sem RevenueCat configurado, planta sem esse vínculo em vez de falhar.
    final planterId = await safePurchasesCall('appUserID', () => Purchases.appUserID);

    while (revenue >= treePriceUsd) {
      try {
        await _treeNationService.plantTree(
          PlantTreeRequest(quantity: 1, planterId: planterId),
        );
        revenue -= treePriceUsd;
        trees += 1;
      } catch (_) {
        // Falha ao plantar de verdade (rede/API indisponível): mantém a
        // receita acumulada para tentar novamente na próxima vez.
        break;
      }
    }

    await _db
        .into(_db.treeProgress)
        .insertOnConflictUpdate(
          TreeProgressCompanion(
            id: const Value(_rowId),
            revenueAccumulatedUsd: Value(revenue),
            treesPlanted: Value(trees),
            updatedAt: Value(DateTime.now()),
          ),
        );

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

    return TreeProgressEntity(
      revenueAccumulatedUsd: revenue,
      treePriceUsd: treePriceUsd,
      treesPlanted: trees,
    );
  }

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
}
