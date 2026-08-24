import '../entities/tree_progress_entity.dart';
import '../repositories/tree_garden_repository.dart';

class WatchAdForTreeUseCase {
  final TreeGardenRepository _repository;

  const WatchAdForTreeUseCase(this._repository);

  Future<TreeProgressEntity> call() => _repository.watchAdAndUpdateProgress();
}
