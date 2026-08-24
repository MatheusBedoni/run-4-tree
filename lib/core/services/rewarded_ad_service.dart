import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Resultado de uma sessão de anúncio recompensado.
class AdWatchResult {
  final bool success;

  /// Receita real (USD) que esse anúncio pagou, vinda do callback
  /// `onPaidEvent` do AdMob. Zero quando [success] é falso.
  final double revenueUsd;

  /// Verdadeiro quando [revenueUsd] é um valor estimado (fallback), porque
  /// a conta AdMob ainda não reporta receita por impressão para essa unidade
  /// de anúncio — ver `_estimatedRevenuePerViewUsd`.
  final bool isEstimatedRevenue;

  final String? errorMessage;

  const AdWatchResult.success(this.revenueUsd, {required this.isEstimatedRevenue})
      : success = true,
        errorMessage = null;

  const AdWatchResult.failure(this.errorMessage)
      : success = false,
        revenueUsd = 0,
        isEstimatedRevenue = false;
}

/// Carrega e exibe um anúncio recompensado, reporta cada evento do ciclo de
/// vida do anúncio para a RevenueCat (`Purchases.adTracker`) e só confirma a
/// recompensa depois da verificação server-side (AdMob SSV) via
/// [Purchases.generateRewardVerificationToken]/[Purchases.pollRewardVerification].
///
/// A recompensa nunca é concedida apenas pelo callback client-side do AdMob —
/// isso evitaria que um cliente adulterado forjasse árvores plantadas.
class RewardedAdService {
  const RewardedAdService();

  static const _placement = 'garden_watch_ad';
  static const _mediatorName = AdMediatorName.adMob;
  static const _adFormat = AdFormat.rewarded;

  /// Usado só quando a conta AdMob ainda não reporta receita por impressão
  /// (`onPaidEvent` nunca dispara nesse caso — comum com unidades de teste ou
  /// contas sem "impression-level ad revenue" habilitado). Ajuste no .env
  /// assim que tiver dados reais de eCPM da sua conta.
  double get _estimatedRevenuePerViewUsd {
    final raw = dotenv.env['ESTIMATED_AD_REVENUE_PER_VIEW_USD'];
    return double.tryParse(raw ?? '') ?? 0.01;
  }

  String get _adUnitId {
    final key = Platform.isIOS
        ? 'ADMOB_REWARDED_AD_UNIT_IOS'
        : 'ADMOB_REWARDED_AD_UNIT_ANDROID';
    return dotenv.env[key] ?? '';
  }

  Future<AdWatchResult> watchAd() async {
    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) {
      return const AdWatchResult.failure('ad_unit_not_configured');
    }

    final completer = Completer<AdWatchResult>();

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _onAdLoaded(ad, completer),
        onAdFailedToLoad: (error) {
          Purchases.adTracker.trackAdFailedToLoad(
            AdFailedToLoadData(
              mediatorName: _mediatorName,
              adFormat: _adFormat,
              placement: _placement,
              adUnitId: adUnitId,
              mediatorErrorCode: error.code,
            ),
          );
          if (!completer.isCompleted) {
            completer.complete(
              AdWatchResult.failure('load_failed: ${error.message}'),
            );
          }
        },
      ),
    );

    return completer.future;
  }

  Future<void> _onAdLoaded(
    RewardedAd ad,
    Completer<AdWatchResult> completer,
  ) async {
    var rewardEarned = false;
    double? capturedRevenueUsd;

    try {
      final impressionId = ad.responseInfo?.responseId;
      if (impressionId == null) {
        ad.dispose();
        completer.complete(const AdWatchResult.failure('missing_impression_id'));
        return;
      }

      Purchases.adTracker.trackAdLoaded(
        AdLoadedData(
          mediatorName: _mediatorName,
          adFormat: _adFormat,
          placement: _placement,
          adUnitId: ad.adUnitId,
          impressionId: impressionId,
        ),
      );

      final token = await Purchases.generateRewardVerificationToken(impressionId);

      await ad.setServerSideOptions(
        ServerSideVerificationOptions(
          userId: token.appUserID,
          customData: token.customData,
        ),
      );

      // Reporta receita por impressão quando a conta AdMob tem "impression-level
      // ad revenue" habilitado; sem isso o callback simplesmente nunca dispara,
      // e ficamos com o valor estimado como fallback (ver `success` abaixo).
      ad.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
        capturedRevenueUsd = valueMicros / 1e6;
        Purchases.adTracker.trackAdRevenue(
          AdRevenueData(
            mediatorName: _mediatorName,
            adFormat: _adFormat,
            placement: _placement,
            adUnitId: ad.adUnitId,
            impressionId: impressionId,
            revenueMicros: valueMicros.round(),
            currency: currencyCode,
            precision: _mapPrecision(precision),
          ),
        );
      };

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          Purchases.adTracker.trackAdDisplayed(
            AdDisplayedData(
              mediatorName: _mediatorName,
              adFormat: _adFormat,
              placement: _placement,
              adUnitId: ad.adUnitId,
              impressionId: impressionId,
            ),
          );
        },
        onAdClicked: (ad) {
          Purchases.adTracker.trackAdOpened(
            AdOpenedData(
              mediatorName: _mediatorName,
              adFormat: _adFormat,
              placement: _placement,
              adUnitId: ad.adUnitId,
              impressionId: impressionId,
            ),
          );
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (!rewardEarned && !completer.isCompleted) {
            completer.complete(const AdWatchResult.failure('dismissed_without_reward'));
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          if (!completer.isCompleted) {
            completer.complete(AdWatchResult.failure('show_failed: ${error.message}'));
          }
        },
      );

      await ad.show(
        onUserEarnedReward: (ad, reward) async {
          rewardEarned = true;
          // A verificação server-side confirma que o anúncio foi mesmo
          // assistido até o fim (anti-fraude) — o valor em USD creditado vem
          // de `onPaidEvent`, não do tipo de recompensa configurado no
          // dashboard da RevenueCat.
          final result = await Purchases.pollRewardVerification(
            token.clientTransactionId,
          );

          if (completer.isCompleted) return;

          if (!result.failed) {
            final revenue = capturedRevenueUsd;
            completer.complete(
              AdWatchResult.success(
                revenue ?? _estimatedRevenuePerViewUsd,
                isEstimatedRevenue: revenue == null,
              ),
            );
          } else {
            completer.complete(const AdWatchResult.failure('verification_failed'));
          }
        },
      );
    } catch (e) {
      ad.dispose();
      debugPrint('RewardedAdService error: $e');
      if (!completer.isCompleted) {
        completer.complete(AdWatchResult.failure(e.toString()));
      }
    }
  }

  AdRevenuePrecision _mapPrecision(PrecisionType precision) {
    switch (precision) {
      case PrecisionType.precise:
        return AdRevenuePrecision.exact;
      case PrecisionType.publisherProvided:
        return AdRevenuePrecision.publisherDefined;
      case PrecisionType.estimated:
        return AdRevenuePrecision.estimated;
      case PrecisionType.unknown:
        return AdRevenuePrecision.unknown;
    }
  }
}
