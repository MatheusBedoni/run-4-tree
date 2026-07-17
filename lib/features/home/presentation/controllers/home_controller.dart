import 'package:flutter/foundation.dart';
import '../../domain/entities/run_stats_entity.dart';
import '../../domain/usecases/get_run_stats_usecase.dart';

/// Controller da HomePage seguindo o padrão ChangeNotifier.
///
/// Gerencia o ciclo de vida do estado (loading → sucesso → erro) e expõe
/// os dados para a UI via [ListenableBuilder] — sem necessidade de Provider
/// ou Bloc para este escopo inicial.
class HomeController extends ChangeNotifier {
  final GetRunStatsUseCase _getRunStatsUseCase;

  HomeController(this._getRunStatsUseCase);

  // ─── Estado ────────────────────────────────────────────────────────────────

  RunStatsEntity? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  RunStatsEntity? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ─── Ações ─────────────────────────────────────────────────────────────────

  /// Carrega as estatísticas da sessão atual.
  Future<void> loadStats() async {
    _setLoading(true);
    try {
      _stats = await _getRunStatsUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os dados. Tente novamente.';
      debugPrint('HomeController.loadStats error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Força um reload dos stats (ex: pull-to-refresh).
  Future<void> refreshStats() => loadStats();

  // ─── Helpers privados ──────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
