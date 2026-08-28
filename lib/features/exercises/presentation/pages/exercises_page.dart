import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../runs/data/datasources/run_session_local_datasource_impl.dart';
import '../../../runs/data/repositories/run_session_repository_impl.dart';
import '../../../runs/domain/entities/run_session_entity.dart';
import '../../../runs/domain/usecases/delete_run_usecase.dart';
import '../../../runs/domain/usecases/get_all_runs_usecase.dart';
import '../controllers/exercises_controller.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late final ExercisesController _controller;

  @override
  void initState() {
    super.initState();

    // Drift: instancia a cadeia datasource → repository → usecases
    final db = AppDatabase.instance;
    final runDataSource = RunSessionLocalDataSourceImpl(db);
    final runRepository = RunSessionRepositoryImpl(runDataSource);
    _controller = ExercisesController(
      GetAllRunsUseCase(runRepository),
      DeleteRunUseCase(runRepository),
    );
    _controller.loadRuns();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homeNavProgress,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildRunHistoryTab(),
    );
  }

  Widget _buildRunHistoryTab() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.runs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDark),
          );
        }

        if (_controller.hasLoadError && _controller.runs.isEmpty) {
          return _buildErrorState(
            AppLocalizations.of(context)!.exercisesLoadErrorMessage,
          );
        }

        if (_controller.runs.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: _controller.refreshRuns,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.runs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final run = _controller.runs[index];
              return _buildRunCard(run);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_run_rounded,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.exercisesEmptyTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.exercisesEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _controller.refreshRuns,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(AppLocalizations.of(context)!.commonRetryButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRunCard(RunSessionEntity run) {
    return Dismissible(
      key: ValueKey(run.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        if (run.id != null) _controller.deleteRun(run.id!);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.progressTrack,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconForExerciseType(run.exerciseType),
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _labelForExerciseType(run.exerciseType),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(run.createdAt),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRunMetric(
                        Icons.route_rounded,
                        '${run.distanceKm.toStringAsFixed(2)} km',
                      ),
                      const SizedBox(width: 16),
                      _buildRunMetric(
                        Icons.timer_rounded,
                        _formatDuration(run.durationSeconds),
                      ),
                      const SizedBox(width: 16),
                      _buildRunMetric(
                        Icons.local_fire_department_rounded,
                        '${run.calories.toStringAsFixed(0)} ${AppLocalizations.of(context)!.exercisesKcalUnit}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunMetric(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  IconData _iconForExerciseType(String exerciseType) {
    switch (exerciseType) {
      case 'bike':
        return Icons.directions_bike_rounded;
      case 'walk':
        return Icons.directions_walk_rounded;
      case 'run':
      default:
        return Icons.directions_run_rounded;
    }
  }

  String _labelForExerciseType(String exerciseType) {
    final l10n = AppLocalizations.of(context)!;
    switch (exerciseType) {
      case 'bike':
        return l10n.exercisesLabelBike;
      case 'walk':
        return l10n.exercisesLabelWalk;
      case 'run':
      default:
        return l10n.exercisesLabelRun;
    }
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h}h${m.toString().padLeft(2, '0')}m';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    final datePart = DateFormat('d MMM', locale).format(date);
    final timePart = DateFormat.Hm(locale).format(date);
    return '$datePart • $timePart';
  }
}
