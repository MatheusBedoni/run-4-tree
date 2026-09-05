import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await _configureRevenueCat();
  await MobileAds.instance.initialize();

  // Status bar transparente para o mapa ocupar a tela toda
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const Run4TreeApp());
}

/// Configura o SDK da RevenueCat com a chave pública da plataforma atual.
/// As chaves ficam no .env (Project Settings > API Keys no dashboard da RevenueCat).
Future<void> _configureRevenueCat() async {
  final apiKey = defaultTargetPlatform == TargetPlatform.iOS
      ? dotenv.env['REVENUECAT_API_KEY_IOS']
      : dotenv.env['REVENUECAT_API_KEY_ANDROID'];

  if (apiKey == null || apiKey.isEmpty) {
    debugPrint('RevenueCat: API key ausente no .env, SDK não configurado.');
    return;
  }

  await Purchases.setLogLevel(
    kDebugMode ? LogLevel.debug : LogLevel.info,
  );
  await Purchases.configure(PurchasesConfiguration(apiKey));
}

class Run4TreeApp extends StatelessWidget {
  const Run4TreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run4Tree',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // English is the app's default/fallback locale — the device locale is
      // used only when it matches one of the locales we actually ship.
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          for (final locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode) {
              return locale;
            }
          }
        }
        return const Locale('en');
      },
      // A SplashPage é a primeira tela: mostra a arte enquanto decide se o
      // destino é '/home' ou '/login'.
      home: const SplashPage(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/onboarding': (_) => const OnboardingPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
