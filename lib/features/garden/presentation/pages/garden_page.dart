import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/tree_garden_repository_impl.dart';
import '../../domain/entities/tree_progress_entity.dart';
import '../../domain/usecases/get_tree_progress_usecase.dart';
import '../../domain/usecases/watch_ad_for_tree_usecase.dart';
import '../controllers/garden_controller.dart';

/// GardenPage — mostra quantas árvores o usuário já plantou e permite
/// assistir a um anúncio recompensado para ganhar sementes rumo à próxima
/// árvore (modelo inspirado no Ecosia).
class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  late final GardenController _controller;

  @override
  void initState() {
    super.initState();
    final repository = TreeGardenRepositoryImpl();
    _controller = GardenController(
      GetTreeProgressUseCase(repository),
      WatchAdForTreeUseCase(repository),
    );
    _controller.loadProgress();
  }

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
                  const Text(
                    'Seu Jardim',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Assista anúncios para plantar árvores de verdade.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                  if (_controller.errorMessage != null) ...[
                    _buildErrorBanner(_controller.errorMessage!),
                    const SizedBox(height: 16),
                  ],
                  _buildWatchAdButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
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
            treesPlanted == 1 ? 'árvore plantada' : 'árvores plantadas',
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
              const Text(
                'Próxima árvore',
                style: TextStyle(
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
                    '$seedsAccumulated/$seedsPerTree sementes',
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

  Widget _buildWatchAdButton() {
    final isWatching = _controller.isWatchingAd;
    return GestureDetector(
      onTap: isWatching ? null : _controller.watchAdForSeed,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.progressGreen, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.progressGreen.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isWatching
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Assistir anúncio e ganhar semente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
