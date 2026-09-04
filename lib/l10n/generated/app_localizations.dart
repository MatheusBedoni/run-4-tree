import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Run4Tree'**
  String get appTitle;

  /// No description provided for @loginTaglineRunPrefix.
  ///
  /// In en, this message translates to:
  /// **'Your run plants '**
  String get loginTaglineRunPrefix;

  /// No description provided for @loginTaglineTreesHighlight.
  ///
  /// In en, this message translates to:
  /// **'real trees.\n'**
  String get loginTaglineTreesHighlight;

  /// No description provided for @loginTaglineOffline.
  ///
  /// In en, this message translates to:
  /// **'Works 100% offline.'**
  String get loginTaglineOffline;

  /// No description provided for @loginFeatureOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet needed'**
  String get loginFeatureOfflineTitle;

  /// No description provided for @loginFeatureOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track runs anywhere'**
  String get loginFeatureOfflineSubtitle;

  /// No description provided for @loginFeatureNoSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'No sign-up or password'**
  String get loginFeatureNoSignupTitle;

  /// No description provided for @loginFeatureNoSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start running in seconds'**
  String get loginFeatureNoSignupSubtitle;

  /// No description provided for @loginFeaturePlantTreesTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant real trees'**
  String get loginFeaturePlantTreesTitle;

  /// No description provided for @loginFeaturePlantTreesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your real impact'**
  String get loginFeaturePlantTreesSubtitle;

  /// No description provided for @loginStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get loginStartButton;

  /// No description provided for @loginChipSustainable.
  ///
  /// In en, this message translates to:
  /// **'SUSTAINABLE'**
  String get loginChipSustainable;

  /// No description provided for @loginChipGamified.
  ///
  /// In en, this message translates to:
  /// **'GAMIFIED'**
  String get loginChipGamified;

  /// No description provided for @homeRunSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Run saved! {distance} km'**
  String homeRunSavedMessage(String distance);

  /// No description provided for @homeRunSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error saving the run.'**
  String get homeRunSaveErrorMessage;

  /// No description provided for @homeMapLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s plant a forest...'**
  String get homeMapLoadingTitle;

  /// No description provided for @homeMapLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Getting GPS location'**
  String get homeMapLoadingSubtitle;

  /// No description provided for @homeUnitKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get homeUnitKm;

  /// No description provided for @homeHudTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get homeHudTimeLabel;

  /// No description provided for @homeHudKmLabel.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get homeHudKmLabel;

  /// No description provided for @homeHudPausedValue.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get homeHudPausedValue;

  /// No description provided for @homeExerciseBike.
  ///
  /// In en, this message translates to:
  /// **'BIKE'**
  String get homeExerciseBike;

  /// No description provided for @homeExerciseWalk.
  ///
  /// In en, this message translates to:
  /// **'WALK'**
  String get homeExerciseWalk;

  /// No description provided for @homeExerciseRun.
  ///
  /// In en, this message translates to:
  /// **'RUN'**
  String get homeExerciseRun;

  /// No description provided for @homeStartLabel.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get homeStartLabel;

  /// No description provided for @homePauseButton.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get homePauseButton;

  /// No description provided for @homeResumeButton.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get homeResumeButton;

  /// No description provided for @homeFinishButton.
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get homeFinishButton;

  /// No description provided for @homeNavActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get homeNavActivity;

  /// No description provided for @homeNavProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get homeNavProgress;

  /// No description provided for @homeNavForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get homeNavForest;

  /// No description provided for @homeNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeNavProfile;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use your name to personalize your journey on Run4Tree.'**
  String get onboardingNameSubtitle;

  /// No description provided for @onboardingNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardingNameFieldLabel;

  /// No description provided for @onboardingAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your age?'**
  String get onboardingAgeTitle;

  /// No description provided for @onboardingAgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us calibrate goals and metrics that fit you better.'**
  String get onboardingAgeSubtitle;

  /// No description provided for @onboardingBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight and height'**
  String get onboardingBodyTitle;

  /// No description provided for @onboardingBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use this data to estimate calories and track your progress.'**
  String get onboardingBodySubtitle;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your weekly goal?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many kilometers do you want to run per week? You can adjust this later.'**
  String get onboardingGoalSubtitle;

  /// No description provided for @onboardingContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinueButton;

  /// No description provided for @onboardingFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingFinishButton;

  /// No description provided for @onboardingSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your data. Please try again.'**
  String get onboardingSaveErrorMessage;

  /// No description provided for @fieldLabelAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get fieldLabelAge;

  /// No description provided for @fieldLabelWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get fieldLabelWeight;

  /// No description provided for @fieldLabelHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get fieldLabelHeight;

  /// No description provided for @fieldLabelWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal'**
  String get fieldLabelWeeklyGoal;

  /// No description provided for @suffixYears.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get suffixYears;

  /// No description provided for @suffixKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get suffixKg;

  /// No description provided for @suffixCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get suffixCm;

  /// No description provided for @suffixKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get suffixKm;

  /// No description provided for @commonRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetryButton;

  /// No description provided for @profileAgeMemberSince.
  ///
  /// In en, this message translates to:
  /// **'{age} years old · member since {date}'**
  String profileAgeMemberSince(int age, String date);

  /// No description provided for @profileEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditButton;

  /// No description provided for @profileGoalCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'This week\'s goal is complete! 🎉'**
  String get profileGoalCompletedMessage;

  /// No description provided for @profileTreesLabel.
  ///
  /// In en, this message translates to:
  /// **'Trees'**
  String get profileTreesLabel;

  /// No description provided for @profileTotalKmLabel.
  ///
  /// In en, this message translates to:
  /// **'total km'**
  String get profileTotalKmLabel;

  /// No description provided for @profileRunsLabel.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get profileRunsLabel;

  /// No description provided for @profileBodyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Body data'**
  String get profileBodyDataTitle;

  /// No description provided for @profileBmiLabel.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get profileBmiLabel;

  /// No description provided for @profileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your profile. Please try again.'**
  String get profileLoadErrorMessage;

  /// No description provided for @profileSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your changes. Please try again.'**
  String get profileSaveErrorMessage;

  /// No description provided for @profileLegalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & About'**
  String get profileLegalSectionTitle;

  /// No description provided for @profileHowWePlantTreesButton.
  ///
  /// In en, this message translates to:
  /// **'How We Plant Real Trees'**
  String get profileHowWePlantTreesButton;

  /// No description provided for @profileTermsButton.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get profileTermsButton;

  /// No description provided for @profilePrivacyButton.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacyButton;

  /// No description provided for @profileLicensesButton.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get profileLicensesButton;

  /// No description provided for @weeklyGoalProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} km'**
  String weeklyGoalProgressLabel(String current, String goal);

  /// No description provided for @editProfileNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editProfileNameFieldLabel;

  /// No description provided for @editProfileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get editProfileSaveButton;

  /// No description provided for @exercisesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No runs recorded yet'**
  String get exercisesEmptyTitle;

  /// No description provided for @exercisesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a run on the main screen to see your history here.'**
  String get exercisesEmptySubtitle;

  /// No description provided for @exercisesLabelBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get exercisesLabelBike;

  /// No description provided for @exercisesLabelWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get exercisesLabelWalk;

  /// No description provided for @exercisesLabelRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get exercisesLabelRun;

  /// No description provided for @exercisesLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your runs. Please try again.'**
  String get exercisesLoadErrorMessage;

  /// No description provided for @exercisesKcalUnit.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get exercisesKcalUnit;

  /// No description provided for @gardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Garden'**
  String get gardenTitle;

  /// No description provided for @gardenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch ads to plant real trees.'**
  String get gardenSubtitle;

  /// No description provided for @gardenTreesPlanted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{tree planted} other{trees planted}}'**
  String gardenTreesPlanted(int count);

  /// No description provided for @gardenNextTreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Next tree'**
  String get gardenNextTreeLabel;

  /// No description provided for @gardenSeedsProgress.
  ///
  /// In en, this message translates to:
  /// **'{accumulated}/{total} seeds'**
  String gardenSeedsProgress(int accumulated, int total);

  /// No description provided for @gardenLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your progress.'**
  String get gardenLoadErrorMessage;

  /// No description provided for @gardenWatchAdErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t play the ad right now.'**
  String get gardenWatchAdErrorMessage;

  /// No description provided for @gardenAdDismissedMessage.
  ///
  /// In en, this message translates to:
  /// **'Ad closed before finishing — watch it to the end to earn the seed.'**
  String get gardenAdDismissedMessage;

  /// No description provided for @gardenAdUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'No ad available right now. Please try again shortly.'**
  String get gardenAdUnavailableMessage;

  /// No description provided for @gardenAdRewardErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t confirm the reward. Please try again.'**
  String get gardenAdRewardErrorMessage;

  /// No description provided for @gardenWatchAdButton.
  ///
  /// In en, this message translates to:
  /// **'Watch ad and earn a seed'**
  String get gardenWatchAdButton;

  /// No description provided for @gardenCo2CompensatedLabel.
  ///
  /// In en, this message translates to:
  /// **'CO2 compensated'**
  String get gardenCo2CompensatedLabel;

  /// No description provided for @gardenCo2CompensatedValue.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg'**
  String gardenCo2CompensatedValue(String kg);

  /// No description provided for @gardenForestTitle.
  ///
  /// In en, this message translates to:
  /// **'Your forest'**
  String get gardenForestTitle;

  /// No description provided for @gardenForestEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No trees planted yet. Watch ads to plant your first one.'**
  String get gardenForestEmptyMessage;

  /// No description provided for @gardenViewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View certificate'**
  String get gardenViewCertificate;

  /// No description provided for @gardenCertificateOpenError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open the certificate link.'**
  String get gardenCertificateOpenError;

  /// No description provided for @exercisesDetailsPace.
  ///
  /// In en, this message translates to:
  /// **'Avg. Pace'**
  String get exercisesDetailsPace;

  /// No description provided for @exercisesDetailsAvgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg. Speed'**
  String get exercisesDetailsAvgSpeed;

  /// No description provided for @exercisesDetailsMaxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get exercisesDetailsMaxSpeed;

  /// No description provided for @exercisesDetailsElevationGain.
  ///
  /// In en, this message translates to:
  /// **'Elevation Gain'**
  String get exercisesDetailsElevationGain;

  /// No description provided for @exercisesDetailsElevationLoss.
  ///
  /// In en, this message translates to:
  /// **'Elevation Loss'**
  String get exercisesDetailsElevationLoss;

  /// No description provided for @exercisesDetailsMaxElevation.
  ///
  /// In en, this message translates to:
  /// **'Max Elevation'**
  String get exercisesDetailsMaxElevation;

  /// No description provided for @exercisesDetailsDehydration.
  ///
  /// In en, this message translates to:
  /// **'Dehydration'**
  String get exercisesDetailsDehydration;

  /// No description provided for @exercisesDetailsSeedsEarned.
  ///
  /// In en, this message translates to:
  /// **'Seeds Earned'**
  String get exercisesDetailsSeedsEarned;

  /// No description provided for @exercisesDetailsStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get exercisesDetailsStartTime;

  /// No description provided for @exercisesDetailsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance ({unit})'**
  String exercisesDetailsDistance(String unit);

  /// No description provided for @exercisesDetailsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get exercisesDetailsDuration;

  /// No description provided for @exercisesDetailsCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get exercisesDetailsCalories;

  /// No description provided for @runCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Run completed!'**
  String get runCompletedTitle;

  /// No description provided for @runCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great job planting {trees} trees'**
  String runCompletedSubtitle(int trees);

  /// No description provided for @runCompletedShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get runCompletedShareButton;

  /// No description provided for @runCompletedShareSummary.
  ///
  /// In en, this message translates to:
  /// **'{exercise} • {distance} km\n\n⏱️ {duration}\n🔥 {calories} kcal\n⚡ Avg. speed: {speed} km/h\n📍 Avg. pace: {pace} min/km'**
  String runCompletedShareSummary(
    Object calories,
    Object distance,
    Object duration,
    Object exercise,
    Object pace,
    Object speed,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
