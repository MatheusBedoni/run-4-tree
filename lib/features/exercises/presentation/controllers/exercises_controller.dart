import 'package:flutter/foundation.dart';

import '../../../runs/domain/entities/run_session_entity.dart';
import '../../../runs/domain/usecases/delete_run_usecase.dart';
import '../../../runs/domain/usecases/get_all_runs_usecase.dart';

/// Controller da ExercisesPage seguindo o padrão ChangeNotifier.
///
/// Carrega o histórico de corridas salvas no Drift e expõe o estado
/// (loading → sucesso → erro) para a UI via [ListenableBuilder].
class ExercisesController extends ChangeNotifier {
  final GetAllRunsUseCase _getAllRunsUseCase;
  final DeleteRunUseCase _deleteRunUseCase;

  ExercisesController(this._getAllRunsUseCase, this._deleteRunUseCase);

  // ─── Estado ────────────────────────────────────────────────────────────────

  List<RunSessionEntity> _runs = [];
  bool _isLoading = false;
  bool _hasLoadError = false;

  List<RunSessionEntity> get runs => _runs;
  bool get isLoading => _isLoading;
  bool get hasLoadError => _hasLoadError;

  // ─── Ações ─────────────────────────────────────────────────────────────────

  /// Carrega o histórico de corridas do usuário.
  Future<void> loadRuns() async {
    _setLoading(true);
    try {
      _runs = await _getAllRunsUseCase();
      _hasLoadError = false;
    } catch (e) {
      _hasLoadError = true;
      debugPrint('ExercisesController.loadRuns error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Força um reload das corridas (ex: pull-to-refresh).
  Future<void> refreshRuns() => loadRuns();

  /// Remove uma corrida pelo ID e atualiza a lista local.
  Future<void> deleteRun(int id) async {
    final previous = _runs;
    _runs = _runs.where((run) => run.id != id).toList();
    notifyListeners();
    try {
      await _deleteRunUseCase(id);
    } catch (e) {
      _runs = previous;
      debugPrint('ExercisesController.deleteRun error: $e');
      notifyListeners();
    }
  }

  // ─── Helpers privados ──────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
