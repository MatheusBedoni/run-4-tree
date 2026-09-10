import '../repositories/global_forest_repository.dart';

class GetTotalTreesPlantedUseCase {
  final GlobalForestRepository _repository;

  const GetTotalTreesPlantedUseCase(this._repository);

  Future<int?> call() => _repository.getTotalTreesPlanted();
}
