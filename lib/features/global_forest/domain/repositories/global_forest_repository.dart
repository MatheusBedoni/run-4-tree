import '../entities/global_planted_tree_entity.dart';

/// Contrato de repositório: o mural global de árvores plantadas por todos os
/// usuários do app — a única parte do app que depende de um servidor externo
/// (Firestore), já que o resto vive só no dispositivo.
abstract class GlobalForestRepository {
  /// Publica uma árvore recém-plantada no mural global. Best-effort: uma
  /// falha aqui nunca deve impedir o plantio local de valer.
  Future<void> publishPlantedTree(GlobalPlantedTreeEntity tree);

  /// Total de árvores já plantadas por todos os usuários do app.
  /// Retorna `null` quando o mural global está indisponível.
  Future<int?> getTotalTreesPlanted();

  /// Página mais recente do mural global, mais recentes primeiro.
  /// Retorna `null` quando o mural global está indisponível.
  Future<List<GlobalPlantedTreeEntity>?> getRecentPlantedTrees({int limit = 30});
}
