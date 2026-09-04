import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../garden/data/repositories/tree_garden_repository_impl.dart';
import '../../../garden/domain/usecases/get_planted_trees_usecase.dart';
import '../../../garden/domain/usecases/get_tree_progress_usecase.dart';
import '../../../garden/presentation/controllers/garden_controller.dart';

/// Explica de forma transparente como o mecanismo "assista anúncio -> planta
/// árvore" funciona de verdade, com os números reais do usuário (não texto
/// genérico) — reaproveita o mesmo [GardenController] da GardenPage.
class HowWePlantTreesPage extends StatefulWidget {
  const HowWePlantTreesPage({super.key});

  @override
  State<HowWePlantTreesPage> createState() => _HowWePlantTreesPageState();
}

class _HowWePlantTreesPageState extends State<HowWePlantTreesPage> {
  late final GardenController _controller;

  @override
  void initState() {
    super.initState();
    final repository = TreeGardenRepositoryImpl();
    _controller = GardenController(
      GetTreeProgressUseCase(repository),
      GetPlantedTreesUseCase(repository),
    );
    _controller.loadProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openTreeNation() async {
    final uri = Uri.parse('https://tree-nation.com');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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
        title: const Text(
          'How We Plant Real Trees',
          style: TextStyle(
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
            final treesPlanted = _controller.progress?.treesPlanted ?? 0;
            final co2Kg = _controller.co2CompensatedKg;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLiveStatsCard(treesPlanted, co2Kg),
                  const SizedBox(height: 24),
                  _section(
                    'No fake points — real trees',
                    'Most apps show you a progress bar that goes nowhere. In Run4Tree, once your progress bar fills '
                        'up, the App places a real, paid order for a tree with Tree-Nation, an independent reforestation '
                        'platform. You can open your Garden tab any time to see every tree you\'ve funded, along with '
                        'its species, country, and a certificate link.',
                  ),
                  _section(
                    'The ads are the funding, not a paywall',
                    'Run4Tree has no subscription and no in-app purchase. Every time you watch a short rewarded ad in '
                        'the Garden tab, the real revenue that ad generates is credited toward the cost of a tree. Once '
                        'enough ad-funded value has accumulated, we place the order — nothing to buy, nothing to unlock.',
                  ),
                  _section(
                    'Verified server-side, so it can\'t be faked',
                    'We use RevenueCat to confirm — on Google\'s own servers, not just on your phone — that an ad was '
                        'genuinely watched to completion before any value is credited. This anti-fraud check protects '
                        'the integrity of every tree planted through the App.',
                  ),
                  _section(
                    'Our reforestation partner',
                    'Tree-Nation plants and tracks real trees around the world and issues a certificate for each one. '
                        'Run4Tree places real orders with them using an anonymous device ID — never your name or any '
                        'personal information.',
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _openTreeNation,
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowUpRightFromSquare,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                    label: const Text(
                      'Visit Tree-Nation',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      side: const BorderSide(color: AppColors.primaryLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLiveStatsCard(int treesPlanted, double co2Kg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.progressGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: _stat(
              FontAwesomeIcons.tree,
              '$treesPlanted',
              treesPlanted == 1 ? 'tree planted by you' : 'trees planted by you',
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _stat(
              FontAwesomeIcons.leaf,
              '${co2Kg.toStringAsFixed(2)} kg',
              'CO2 compensated',
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(FaIconData icon, String value, String label) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 10),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
        ),
      ],
    );
  }

  Widget _section(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
