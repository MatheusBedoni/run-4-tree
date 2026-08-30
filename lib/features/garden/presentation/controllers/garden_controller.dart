import 'package:flutter/foundation.dart';

import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';

enum GardenError { loadFailed }

/// Controller da GardenPage seguindo o padrão ChangeNotifier usado no resto do app.
class GardenController extends ChangeNotifier {
  final GetTreeProgressUseCase _getTreeProgressUseCase;

  GardenController(this._getTreeProgressUseCase);

  TreeProgressEntity? _progress;
  bool _isLoading = false;
  GardenError? _error;

  TreeProgressEntity? get progress => _progress;
  bool get isLoading => _isLoading;
  GardenError? get error => _error;

  Future<void> loadProgress() async {
    _setLoading(true);
    try {
      _progress = await _getTreeProgressUseCase();
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
