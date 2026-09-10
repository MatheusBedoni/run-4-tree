import '../entities/global_planted_tree_entity.dart';
import '../repositories/global_forest_repository.dart';

class PublishPlantedTreeUseCase {
  final GlobalForestRepository _repository;

  const PublishPlantedTreeUseCase(this._repository);

  Future<void> call(GlobalPlantedTreeEntity tree) => _repository.publishPlantedTree(tree);
}
