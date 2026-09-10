import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/repositories/global_forest_repository_impl.dart';
import '../../domain/entities/global_planted_tree_entity.dart';
import '../../domain/usecases/get_recent_planted_trees_usecase.dart';
import '../../domain/usecases/get_total_trees_planted_usecase.dart';
import '../controllers/global_forest_controller.dart';

/// Mural global: mostra quantas árvores TODOS os usuários do app já
/// plantaram de verdade, e a lista mais recente — lido do Firestore, a única
/// parte do app que depende de um servidor externo.
class GlobalForestPage extends StatefulWidget {
  const GlobalForestPage({super.key});

  @override
  State<GlobalForestPage> createState() => _GlobalForestPageState();
}

class _GlobalForestPageState extends State<GlobalForestPage> {
  late final GlobalForestController _controller;

  @override
  void initState() {
    super.initState();
    final repository = GlobalForestRepositoryImpl();
    _controller = GlobalForestController(
      GetTotalTreesPlantedUseCase(repository),
      GetRecentPlantedTreesUseCase(repository),
    );
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCertificate(String url) async {
    final uri = Uri.tryParse(url);
    final launched =
        uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.gardenCertificateOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          AppLocalizations.of(context)!.globalForestPageTitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.totalTreesPlanted == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _controller.load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.globalForestSubtitle,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    _buildTotalCard(_controller.totalTreesPlanted),
                    const SizedBox(height: 28),
                    Text(
                      AppLocalizations.of(context)!.globalForestRecentTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_controller.error != null)
                      _buildErrorBanner(
                        AppLocalizations.of(context)!.globalForestUnavailableMessage,
                      )
                    else
                      _buildForestGrid(_controller.recentTrees),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTotalCard(int? total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.progressGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white, width: 2),
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.earthAmericas, color: Colors.white, size: 26),
          const SizedBox(height: 12),
          Text(
            total == null ? '—' : '$total',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.globalForestTotalLabel(total ?? 0),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildForestGrid(List<GlobalPlantedTreeEntity> trees) {
    if (trees.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons.seedling,
              size: 28,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.globalForestEmptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trees.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) => _buildTreeCard(trees[index]),
    );
  }

  Widget _buildTreeCard(GlobalPlantedTreeEntity tree) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.progressTrack),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.tree, color: AppColors.primaryDark, size: 18),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tree.speciesName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            tree.country,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _openCertificate(tree.certificateUrl),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.certificate, size: 12, color: AppColors.primaryLight),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.gardenViewCertificate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ],
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
            child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
