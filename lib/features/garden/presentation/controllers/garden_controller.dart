import 'package:flutter/foundation.dart';

import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/repositories/tree_garden_repository.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';
import '../../domain/usecases/watch_ad_for_tree_usecase.dart';

/// Controller da GardenPage seguindo o padrão ChangeNotifier usado no resto do app.
class GardenController extends ChangeNotifier {
  final GetTreeProgressUseCase _getTreeProgressUseCase;
  final WatchAdForTreeUseCase _watchAdForTreeUseCase;

  GardenController(this._getTreeProgressUseCase, this._watchAdForTreeUseCase);

  TreeProgressEntity? _progress;
  bool _isLoading = false;
  bool _isWatchingAd = false;
  String? _errorMessage;

  TreeProgressEntity? get progress => _progress;
  bool get isLoading => _isLoading;
  bool get isWatchingAd => _isWatchingAd;
  String? get errorMessage => _errorMessage;

  Future<void> loadProgress() async {
    _setLoading(true);
    try {
      _progress = await _getTreeProgressUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar seu progresso.';
      debugPrint('GardenController.loadProgress error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> watchAdForSeed() async {
    if (_isWatchingAd) return;

    _isWatchingAd = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _progress = await _watchAdForTreeUseCase();
    } on AdRewardException catch (e) {
      _errorMessage = _messageFor(e.reason);
    } catch (e) {
      _errorMessage = 'Não foi possível assistir ao anúncio agora.';
      debugPrint('GardenController.watchAdForSeed error: $e');
    } finally {
      _isWatchingAd = false;
      notifyListeners();
    }
  }

  String _messageFor(String reason) {
    switch (reason) {
      case 'dismissed_without_reward':
        return 'Anúncio fechado antes do fim — assista até o final para ganhar a semente.';
      case 'ad_unit_not_configured':
      case 'load_failed':
        return 'Nenhum anúncio disponível no momento. Tente novamente em instantes.';
      default:
        return 'Não foi possível confirmar a recompensa. Tente novamente.';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
