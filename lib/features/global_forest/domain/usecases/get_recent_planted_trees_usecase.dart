import '../entities/global_planted_tree_entity.dart';
import '../repositories/global_forest_repository.dart';

class GetRecentPlantedTreesUseCase {
  final GlobalForestRepository _repository;

  const GetRecentPlantedTreesUseCase(this._repository);

  Future<List<GlobalPlantedTreeEntity>?> call({int limit = 30}) =>
      _repository.getRecentPlantedTrees(limit: limit);
}
