import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:run_4_tree/core/theme/app_colors.dart';
import 'package:run_4_tree/l10n/generated/app_localizations.dart';
import 'package:run_4_tree/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:run_4_tree/features/profile/domain/entities/profile_entity.dart';
import 'package:run_4_tree/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:run_4_tree/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:run_4_tree/features/profile/presentation/controllers/profile_controller.dart';
import 'package:run_4_tree/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    final repository = ProfileRepositoryImpl();
    _controller = ProfileController(
      GetProfileUseCase(repository),
      UpdateProfileUseCase(repository),
    );
    _controller.loadProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openEditProfile(ProfileEntity profile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(controller: _controller, profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.accentOrange),
            );
          }

          if (_controller.hasLoadError && _controller.profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.profileLoadErrorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _controller.loadProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(AppLocalizations.of(context)!.commonRetryButton),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = _controller.profile;
          if (profile == null) return const SizedBox();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.profileAgeMemberSince(
                      profile.age,
                      _formatMonthYear(profile.memberSince),
                    ),
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openEditProfile(profile),
                      icon: Icon(Icons.edit_rounded, size: 18, color: AppColors.primaryDark),
                      label: Text(
                        AppLocalizations.of(context)!.profileEditButton,
                        style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primaryLight),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildWeeklyGoalCard(profile),
                  const SizedBox(height: 24),
                  _buildStatsGrid(profile),
                  const SizedBox(height: 24),
                  _buildBodyInfoCard(profile),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.seedling, color: Colors.white, size: 36),
      ),
    );
  }

  Widget _buildWeeklyGoalCard(ProfileEntity profile) {
    final progress = profile.weeklyGoalProgress;
    final reachedGoal = progress >= 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: AppColors.primaryDark, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.fieldLabelWeeklyGoal,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.weeklyGoalProgressLabel(
                  profile.weeklyDistanceKm.toStringAsFixed(1),
                  profile.weeklyGoalKm.toStringAsFixed(1),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: reachedGoal ? AppColors.primaryDark : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation(
                reachedGoal ? AppColors.progressGreen : AppColors.primaryLight,
              ),
            ),
          ),
          if (reachedGoal) ...[
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.profileGoalCompletedMessage,
              style: TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ProfileEntity profile) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: FaIcon(FontAwesomeIcons.tree, color: AppColors.primaryLight, size: 22),
            value: '${profile.treesPlanted}',
            label: AppLocalizations.of(context)!.profileTreesLabel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icon(Icons.route_rounded, color: AppColors.skyBlue, size: 24),
            value: profile.totalDistanceKm.toStringAsFixed(1),
            label: AppLocalizations.of(context)!.profileTotalKmLabel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icon(Icons.directions_run_rounded, color: AppColors.accentOrange, size: 24),
            value: '${profile.totalRuns}',
            label: AppLocalizations.of(context)!.profileRunsLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Widget icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyInfoCard(ProfileEntity profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monitor_weight_outlined, color: AppColors.primaryDark, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.profileBodyDataTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBodyInfoItem(
                AppLocalizations.of(context)!.fieldLabelWeight,
                '${profile.weightKg.toStringAsFixed(1)} ${AppLocalizations.of(context)!.suffixKg}',
              ),
              _buildBodyInfoDivider(),
              _buildBodyInfoItem(
                AppLocalizations.of(context)!.fieldLabelHeight,
                '${profile.heightCm.toStringAsFixed(0)} ${AppLocalizations.of(context)!.suffixCm}',
              ),
              _buildBodyInfoDivider(),
              _buildBodyInfoItem(AppLocalizations.of(context)!.profileBmiLabel, profile.bmi.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBodyInfoDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.background,
    );
  }

  String _formatMonthYear(DateTime date) {
    return DateFormat(
      'MMM/y',
      Localizations.localeOf(context).toString(),
    ).format(date);
  }
}
