import 'package:flutter/foundation.dart';

import '../../domain/entities/global_planted_tree_entity.dart';
import '../../domain/usecases/get_recent_planted_trees_usecase.dart';
import '../../domain/usecases/get_total_trees_planted_usecase.dart';

enum GlobalForestError { unavailable }

/// Controller da GlobalForestPage seguindo o padrão ChangeNotifier usado no
/// resto do app.
class GlobalForestController extends ChangeNotifier {
  final GetTotalTreesPlantedUseCase _getTotalTreesPlantedUseCase;
  final GetRecentPlantedTreesUseCase _getRecentPlantedTreesUseCase;

  GlobalForestController(
    this._getTotalTreesPlantedUseCase,
    this._getRecentPlantedTreesUseCase,
  );

  int? _totalTreesPlanted;
  List<GlobalPlantedTreeEntity> _recentTrees = const [];
  bool _isLoading = false;
  GlobalForestError? _error;

  int? get totalTreesPlanted => _totalTreesPlanted;
  List<GlobalPlantedTreeEntity> get recentTrees => _recentTrees;
  bool get isLoading => _isLoading;
  GlobalForestError? get error => _error;

  Future<void> load() async {
    _setLoading(true);
    final total = await _getTotalTreesPlantedUseCase();
    final recent = await _getRecentPlantedTreesUseCase();

    _totalTreesPlanted = total;
    if (recent != null) _recentTrees = recent;
    _error = (total == null && recent == null) ? GlobalForestError.unavailable : null;

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
