// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Run4Tree';

  @override
  String get loginTaglineRunPrefix => 'Your run plants ';

  @override
  String get loginTaglineTreesHighlight => 'real trees.\n';

  @override
  String get loginTaglineOffline => 'Works 100% offline.';

  @override
  String get loginFeatureOfflineTitle => 'No internet needed';

  @override
  String get loginFeatureOfflineSubtitle => 'Track runs anywhere';

  @override
  String get loginFeatureNoSignupTitle => 'No sign-up or password';

  @override
  String get loginFeatureNoSignupSubtitle => 'Start running in seconds';

  @override
  String get loginFeaturePlantTreesTitle => 'Plant real trees';

  @override
  String get loginFeaturePlantTreesSubtitle => 'Track your real impact';

  @override
  String get loginStartButton => 'Start now';

  @override
  String get loginChipSustainable => 'SUSTAINABLE';

  @override
  String get loginChipGamified => 'GAMIFIED';

  @override
  String homeRunSavedMessage(String distance) {
    return 'Run saved! $distance km';
  }

  @override
  String get homeRunSaveErrorMessage => 'Error saving the run.';

  @override
  String get homeMapLoadingTitle => 'Let\'s plant a forest...';

  @override
  String get homeMapLoadingSubtitle => 'Getting GPS location';

  @override
  String get homeUnitKm => 'km';

  @override
  String get homeHudTimeLabel => 'TIME';

  @override
  String get homeHudKmLabel => 'KM';

  @override
  String get homeHudPausedValue => 'PAUSED';

  @override
  String get homeExerciseBike => 'BIKE';

  @override
  String get homeExerciseWalk => 'WALK';

  @override
  String get homeExerciseRun => 'RUN';

  @override
  String get homeStartLabel => 'START';

  @override
  String get homePauseButton => 'PAUSE';

  @override
  String get homeResumeButton => 'RESUME';

  @override
  String get homeFinishButton => 'FINISH';

  @override
  String get homeNavActivity => 'Activity';

  @override
  String get homeNavProgress => 'Progress';

  @override
  String get homeNavForest => 'Forest';

  @override
  String get homeNavProfile => 'Profile';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingNameSubtitle =>
      'We\'ll use your name to personalize your journey on Run4Tree.';

  @override
  String get onboardingNameFieldLabel => 'Your name';

  @override
  String get onboardingAgeTitle => 'What\'s your age?';

  @override
  String get onboardingAgeSubtitle =>
      'This helps us calibrate goals and metrics that fit you better.';

  @override
  String get onboardingBodyTitle => 'Weight and height';

  @override
  String get onboardingBodySubtitle =>
      'We use this data to estimate calories and track your progress.';

  @override
  String get onboardingGoalTitle => 'What\'s your weekly goal?';

  @override
  String get onboardingGoalSubtitle =>
      'How many kilometers do you want to run per week? You can adjust this later.';

  @override
  String get onboardingContinueButton => 'Continue';

  @override
  String get onboardingFinishButton => 'Finish';

  @override
  String get onboardingSaveErrorMessage =>
      'We couldn\'t save your data. Please try again.';

  @override
  String get fieldLabelAge => 'Age';

  @override
  String get fieldLabelWeight => 'Weight';

  @override
  String get fieldLabelHeight => 'Height';

  @override
  String get fieldLabelWeeklyGoal => 'Weekly goal';

  @override
  String get suffixYears => 'years';

  @override
  String get suffixKg => 'kg';

  @override
  String get suffixCm => 'cm';

  @override
  String get suffixKm => 'km';

  @override
  String get commonRetryButton => 'Try again';

  @override
  String profileAgeMemberSince(int age, String date) {
    return '$age years old · member since $date';
  }

  @override
  String get profileEditButton => 'Edit profile';

  @override
  String get profileGoalCompletedMessage => 'This week\'s goal is complete! 🎉';

  @override
  String get profileTreesLabel => 'Trees';

  @override
  String get profileTotalKmLabel => 'total km';

  @override
  String get profileRunsLabel => 'Runs';

  @override
  String get profileBodyDataTitle => 'Body data';

  @override
  String get profileBmiLabel => 'BMI';

  @override
  String get profileLoadErrorMessage =>
      'We couldn\'t load your profile. Please try again.';

  @override
  String get profileSaveErrorMessage =>
      'We couldn\'t save your changes. Please try again.';

  @override
  String get profileLegalSectionTitle => 'Legal & About';

  @override
  String get profileHowWePlantTreesButton => 'How We Plant Real Trees';

  @override
  String get profileTermsButton => 'Terms of Service';

  @override
  String get profilePrivacyButton => 'Privacy Policy';

  @override
  String get profileLicensesButton => 'Open Source Licenses';

  @override
  String weeklyGoalProgressLabel(String current, String goal) {
    return '$current / $goal km';
  }

  @override
  String get editProfileNameFieldLabel => 'Name';

  @override
  String get editProfileSaveButton => 'Save changes';

  @override
  String get exercisesEmptyTitle => 'No runs recorded yet';

  @override
  String get exercisesEmptySubtitle =>
      'Start a run on the main screen to see your history here.';

  @override
  String get exercisesLabelBike => 'Bike';

  @override
  String get exercisesLabelWalk => 'Walk';

  @override
  String get exercisesLabelRun => 'Run';

  @override
  String get exercisesLoadErrorMessage =>
      'We couldn\'t load your runs. Please try again.';

  @override
  String get exercisesKcalUnit => 'kcal';

  @override
  String get gardenTitle => 'Your Garden';

  @override
  String get gardenSubtitle => 'Watch ads to plant real trees.';

  @override
  String gardenTreesPlanted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'trees planted',
      one: 'tree planted',
    );
    return '$_temp0';
  }

  @override
  String get gardenNextTreeLabel => 'Next tree';

  @override
  String gardenSeedsProgress(int accumulated, int total) {
    return '$accumulated/$total seeds';
  }

  @override
  String get gardenLoadErrorMessage => 'We couldn\'t load your progress.';

  @override
  String get gardenWatchAdErrorMessage => 'We couldn\'t play the ad right now.';

  @override
  String get gardenAdDismissedMessage =>
      'Ad closed before finishing — watch it to the end to earn the seed.';

  @override
  String get gardenAdUnavailableMessage =>
      'No ad available right now. Please try again shortly.';

  @override
  String get gardenAdRewardErrorMessage =>
      'We couldn\'t confirm the reward. Please try again.';

  @override
  String get gardenWatchAdButton => 'Watch ad and earn a seed';

  @override
  String get gardenCo2CompensatedLabel => 'CO2 compensated';

  @override
  String gardenCo2CompensatedValue(String kg) {
    return '$kg kg';
  }

  @override
  String get gardenForestTitle => 'Your forest';

  @override
  String get gardenForestEmptyMessage =>
      'No trees planted yet. Watch ads to plant your first one.';

  @override
  String get gardenViewCertificate => 'View certificate';

  @override
  String get gardenCertificateOpenError =>
      'We couldn\'t open the certificate link.';

  @override
  String get exercisesDetailsPace => 'Avg. Pace';

  @override
  String get exercisesDetailsAvgSpeed => 'Avg. Speed';

  @override
  String get exercisesDetailsMaxSpeed => 'Max Speed';

  @override
  String get exercisesDetailsElevationGain => 'Elevation Gain';

  @override
  String get exercisesDetailsElevationLoss => 'Elevation Loss';

  @override
  String get exercisesDetailsMaxElevation => 'Max Elevation';

  @override
  String get exercisesDetailsDehydration => 'Dehydration';

  @override
  String get exercisesDetailsSeedsEarned => 'Seeds Earned';

  @override
  String get exercisesDetailsStartTime => 'Start Time';

  @override
  String exercisesDetailsDistance(String unit) {
    return 'Distance ($unit)';
  }

  @override
  String get exercisesDetailsDuration => 'Duration';

  @override
  String get exercisesDetailsCalories => 'Calories';

  @override
  String get runCompletedTitle => 'Run completed!';

  @override
  String runCompletedSubtitle(int trees) {
    return 'Great job planting $trees trees';
  }

  @override
  String get runCompletedShareButton => 'Share';

  @override
  String runCompletedShareSummary(
    Object calories,
    Object distance,
    Object duration,
    Object exercise,
    Object pace,
    Object speed,
  ) {
    return '$exercise • $distance km\n\n⏱️ $duration\n🔥 $calories kcal\n⚡ Avg. speed: $speed km/h\n📍 Avg. pace: $pace min/km';
  }
}
