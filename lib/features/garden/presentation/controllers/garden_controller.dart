import 'package:flutter/foundation.dart';

import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/repositories/tree_garden_repository.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';
import '../../domain/usecases/watch_ad_for_tree_usecase.dart';

enum GardenError { loadFailed, adPlaybackFailed, adDismissed, adUnavailable, rewardFailed }

/// Controller da GardenPage seguindo o padrão ChangeNotifier usado no resto do app.
class GardenController extends ChangeNotifier {
  final GetTreeProgressUseCase _getTreeProgressUseCase;
  final WatchAdForTreeUseCase _watchAdForTreeUseCase;

  GardenController(this._getTreeProgressUseCase, this._watchAdForTreeUseCase);

  TreeProgressEntity? _progress;
  bool _isLoading = false;
  bool _isWatchingAd = false;
  GardenError? _error;

  TreeProgressEntity? get progress => _progress;
  bool get isLoading => _isLoading;
  bool get isWatchingAd => _isWatchingAd;
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

  Future<void> watchAdForSeed() async {
    if (_isWatchingAd) return;

    _isWatchingAd = true;
    _error = null;
    notifyListeners();

    try {
      _progress = await _watchAdForTreeUseCase();
    } on AdRewardException catch (e) {
      _error = _errorFor(e.reason);
    } catch (e) {
      _error = GardenError.adPlaybackFailed;
      debugPrint('GardenController.watchAdForSeed error: $e');
    } finally {
      _isWatchingAd = false;
      notifyListeners();
    }
  }

  GardenError _errorFor(String reason) {
    switch (reason) {
      case 'dismissed_without_reward':
        return GardenError.adDismissed;
      case 'ad_unit_not_configured':
      case 'load_failed':
        return GardenError.adUnavailable;
      default:
        return GardenError.rewardFailed;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
