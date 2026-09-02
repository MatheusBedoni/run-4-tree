import '../entities/planted_tree_entity.dart';
import '../entities/tree_progress_entity.dart';

/// Contrato de repositório: define o que o domínio espera da camada de dados
/// para o fluxo "receita de anúncio -> ganhar semente -> plantar árvore".
abstract class TreeGardenRepository {
  Future<TreeProgressEntity> getProgress();

  /// Credita [revenueUsd] (já obtida e verificada por quem assistiu o
  /// anúncio) ao progresso acumulado e, se atingir o limiar, planta uma
  /// árvore de verdade via Tree-Nation.
  Future<TreeProgressEntity> creditAdRevenueAndUpdateProgress(double revenueUsd);

  /// Todas as árvores já plantadas de verdade, mais recentes primeiro —
  /// usado para exibir a floresta do usuário.
  Future<List<PlantedTreeEntity>> getPlantedTrees();
}
