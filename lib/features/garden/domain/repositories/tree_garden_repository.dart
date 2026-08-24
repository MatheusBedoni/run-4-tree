import '../entities/tree_progress_entity.dart';

/// Contrato de repositório: define o que o domínio espera da camada de dados
/// para o fluxo "assistir anúncio -> ganhar semente -> plantar árvore".
abstract class TreeGardenRepository {
  Future<TreeProgressEntity> getProgress();

  /// Exibe um anúncio recompensado, valida a recompensa via RevenueCat e,
  /// se as sementes acumuladas atingirem o limiar, planta uma árvore de
  /// verdade via Tree-Nation. Lança [AdRewardException] em caso de falha.
  Future<TreeProgressEntity> watchAdAndUpdateProgress();
}

class AdRewardException implements Exception {
  final String reason;
  const AdRewardException(this.reason);

  @override
  String toString() => 'AdRewardException: $reason';
}
