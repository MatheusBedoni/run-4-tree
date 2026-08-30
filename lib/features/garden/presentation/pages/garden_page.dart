import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/repositories/tree_garden_repository_impl.dart';
import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';
import '../controllers/garden_controller.dart';

/// GardenPage — mostra quantas árvores o usuário já plantou e o progresso
/// rumo à próxima, alimentado pelos anúncios exibidos durante o ciclo de
/// uma corrida (início, fim e banner).
class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => GardenPageState();
}

class GardenPageState extends State<GardenPage> {
  late final GardenController _controller;

  @override
  void initState() {
    super.initState();
    final repository = TreeGardenRepositoryImpl();
    _controller = GardenController(GetTreeProgressUseCase(repository));
    _controller.loadProgress();
  }

  /// Recarrega o progresso — chamado pela Home quando o usuário navega até
  /// essa aba, já que ela vive dentro de um `IndexedStack` e não seria
  /// reconstruída sozinha depois de uma corrida.
  Future<void> refresh() => _controller.loadProgress();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.progress == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final progress = _controller.progress;
            final treesPlanted = progress?.treesPlanted ?? 0;
            final progressPercent = progress?.progressPercent ?? 0.0;
            final seedsAccumulated = progress?.seedsAccumulated ?? 0;
            const seedsPerTree = TreeProgressEntity.seedsPerTree;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.gardenTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.gardenSubtitle,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),
                  _buildTreesCard(treesPlanted),
                  const SizedBox(height: 20),
                  _buildProgressCard(
                    seedsAccumulated: seedsAccumulated,
                    seedsPerTree: seedsPerTree,
                    progressPercent: progressPercent,
                  ),
                  const SizedBox(height: 20),
                  if (_controller.error != null)
                    _buildErrorBanner(_messageFor(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _messageFor(BuildContext context) {
    return AppLocalizations.of(context)!.gardenLoadErrorMessage;
  }

  Widget _buildTreesCard(int treesPlanted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.progressGreen, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.progressGreen.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.tree, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$treesPlanted',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.gardenTreesPlanted(treesPlanted),
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required int seedsAccumulated,
    required int seedsPerTree,
    required double progressPercent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.gardenNextTreeLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.seedling,
                    size: 14,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.gardenSeedsProgress(
                      seedsAccumulated,
                      seedsPerTree,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercent,
              minHeight: 10,
              backgroundColor: AppColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation(AppColors.progressGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
