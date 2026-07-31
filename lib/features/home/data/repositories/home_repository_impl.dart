import '../../domain/entities/run_stats_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/run_stats_model.dart';

/// Implementação concreta do [HomeRepository].
///
/// Atualmente retorna dados mock idênticos ao protótipo (12 árvores, 4.57 km,
/// 65%, 24°C). Quando a API estiver pronta, basta substituir o bloco dentro
/// de [getRunStats] por uma chamada HTTP/Firestore sem alterar nada no domínio
/// ou na presentation.
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<RunStatsEntity> getRunStats() async {
    // TODO: substituir por chamada real à API quando disponível.
    await Future.delayed(const Duration(milliseconds: 600)); // simula latência

    return const RunStatsModel(
      treesPlanted: 0,
      distanceKm: 0,
      progressPercent: 0,
      weatherTemp: 0,
      weatherCondition: 'sunny',
    );
  }
}
