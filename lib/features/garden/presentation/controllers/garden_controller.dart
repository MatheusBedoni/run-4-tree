import 'package:flutter/foundation.dart';

import '../../domain/entities/planted_tree_entity.dart';
import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/usecases/get_planted_trees_usecase.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';

enum GardenError { loadFailed }

/// Controller da GardenPage seguindo o padrão ChangeNotifier usado no resto do app.
class GardenController extends ChangeNotifier {
  final GetTreeProgressUseCase _getTreeProgressUseCase;
  final GetPlantedTreesUseCase _getPlantedTreesUseCase;

  GardenController(this._getTreeProgressUseCase, this._getPlantedTreesUseCase);

  TreeProgressEntity? _progress;
  List<PlantedTreeEntity> _plantedTrees = const [];
  bool _isLoading = false;
  GardenError? _error;

  TreeProgressEntity? get progress => _progress;
  List<PlantedTreeEntity> get plantedTrees => _plantedTrees;
  bool get isLoading => _isLoading;
  GardenError? get error => _error;

  /// CO2 total (kg) já compensado pelas árvores plantadas — soma do
  /// `species_life_time_CO2` de cada árvore da floresta do usuário.
  double get co2CompensatedKg =>
      _plantedTrees.fold(0.0, (sum, tree) => sum + tree.co2LifeTimeKg);

  Future<void> loadProgress() async {
    _setLoading(true);
    try {
      _progress = await _getTreeProgressUseCase();
      _plantedTrees = await _getPlantedTreesUseCase();
      _error = null;
    } catch (e) {
      _error = GardenError.loadFailed;
      debugPrint('GardenController.loadProgress error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
