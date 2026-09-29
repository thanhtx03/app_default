import 'dart:developer' as developer;
import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Service wrapper for ExoAds initialization and lifecycle hooks.
class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  bool _initialized = false;
  bool _isListening = false;

  DateTime? _lastInterShowTime;
  final DateTime _appStartTime = DateTime.now();

  bool _isInterAd(AdEvent event) {
    return event.adUnitType == AdUnitType.interstitial ||
        event.adUnitType == AdUnitType.rewardedInterstitial ||
        event.adUnitType == AdUnitType.nativeFull ||
        event.adKey.contains('inter') ||
        event.adKey.contains('ad_in_');
  }

  void _logInterIntervalIfNeeded(AdEvent event) {
    if (!_isInterAd(event)) return;

    final interConfig = ExoAds.instance.config.interConfig;
    final betweenSec = interConfig.betweenInterval;
    final startSec = interConfig.startInterval;
    final now = DateTime.now();
    final uptimeSec = now.difference(_appStartTime).inMilliseconds / 1000.0;

    String intervalStatus;
    if (_lastInterShowTime == null) {
      intervalStatus = 'First Inter Ad | App Uptime: ${uptimeSec.toStringAsFixed(1)}s';
    } else {
      final elapsedSec = now.difference(_lastInterShowTime!).inMilliseconds / 1000.0;
      if (elapsedSec < betweenSec) {
        final remaining = (betweenSec - elapsedSec).clamp(0.0, betweenSec.toDouble());
        intervalStatus = 'Last Inter: ${elapsedSec.toStringAsFixed(1)}s ago | Cooldown remaining: ${remaining.toStringAsFixed(1)}s ⏳';
      } else {
        intervalStatus = 'Last Inter: ${elapsedSec.toStringAsFixed(1)}s ago | Interval Passed Ready ✅';
      }
    }

    _logToLogcat(
      '⏱️ [INTER INTERVAL] Ad: "${event.adKey}" | Config (between_itval: ${betweenSec}s, start_itval: ${startSec}s) | $intervalStatus',
    );
  }

  /// Lắng nghe các sự kiện của ExoAds và in log tên Ads (adKey) ra Logcat
  void listenToAdEvents() {
    if (_isListening) return;
    _isListening = true;

    ExoAds.instance.onEvent.listen((event) {
      final adName = event.adKey;
      final type = event.adUnitType.name;
      final network = event.adNetwork.name;

      switch (event.type) {
        case AdEventType.showed:
          _logToLogcat(
            '📺 [ADS SHOWING] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          _logInterIntervalIfNeeded(event);
          if (_isInterAd(event)) {
            _lastInterShowTime = DateTime.now();
          }
          break;
        case AdEventType.impression:
          _logToLogcat(
            '👁️ [ADS IMPRESSION] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          break;
        case AdEventType.loaded:
          _logToLogcat(
            '✅ [ADS LOADED] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          break;
        case AdEventType.failedToShow:
          _logToLogcat(
            '❌ [ADS FAILED TO SHOW] Ad Name/Key: "$adName" | Error: ${event.errorMessage}',
          );
          _logInterIntervalIfNeeded(event);
          break;
        case AdEventType.failedToLoad:
          _logToLogcat(
            '⚠️ [ADS FAILED TO LOAD] Ad Name/Key: "$adName" | Error: ${event.errorMessage}',
          );
          break;
        case AdEventType.clicked:
          _logToLogcat(
            '👉 [ADS CLICKED] Ad Name/Key: "$adName" | Type: $type',
          );
          break;
        case AdEventType.dismissed:
          _logToLogcat(
            '🚪 [ADS DISMISSED] Ad Name/Key: "$adName" | Type: $type',
          );
          break;
        default:
          break;
      }
    });
  }

  void _logToLogcat(String message) {
    debugPrint(message);
    developer.log(message, name: 'ExoAdsLogcat');
  }

  /// Initialize ExoAds, fetch remote config, and register ads.
  Future<void> initialize() async {

    // Setup UI for Welcome Back Screen

    ExoAds.instance.welcomeBackLogo = Image.asset(
      'assets/icons/ic_app.png',
      width: 50,
      height: 50,
    );
    ExoAds.instance.welcomeBackCenterImage = Image.asset(
      'assets/a_startup/images/img_welcome_back.png',
      width: 335,
      height: 335,
    );
    //ExoAds.instance.welcomeBackBackgroundColor = SStartupColors.background;
    ExoAds.instance.welcomeBackAppName = () => 'app_default';
    ExoAds.instance.welcomeBackText = () => 'Welcome to our app'.tr;
    ExoAds.instance.welcomeBackNextButtonText = () => 'Continue'.tr;
    ExoAds.instance.welcomeBackButtonColor = AppColors.primaryTransparent;
    ExoAds.instance.welcomeBackButtonTextColor = AppColors.primary;
    ExoAds.instance.welcomeBackButtonMargin = const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.welcomeBackButtonPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16);

    // Setup UI for No Internet Screen
    ExoAds.instance.noInternetIllustration = Image.asset(
      'assets/a_startup/images/img_no_internet.png',
      width: 268,
      height: 268,
    );
    ExoAds.instance.noInternetBackgroundColor = AppColors.background;
    ExoAds.instance.noInternetTitle = () => 'No Internet'.tr;
    ExoAds.instance.noInternetSubtitle = () => 'No internet connection'.tr;
    ExoAds.instance.noInternetDescription = () => 'No internet connection available due \nto network or service issue'.tr;
    ExoAds.instance.noInternetRetryLabel = () => 'Try Again'.tr;
    ExoAds.instance.noInternetButtonColor = AppColors.primary;
    ExoAds.instance.noInternetButtonTextColor = AppColors.textPrimary;
    ExoAds.instance.noInternetButtonMargin = const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.noInternetButtonPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
    ExoAds.instance.onRestartToSplash = () {
    //Get.offAllNamed(AppRoutes.splash);
    };
    
    listenToAdEvents();

    if (_initialized) return;

    ExoAdBase.useNativePlatformFactory = true;
    ExoAds.navigatorKey = Get.key; // REQUIRED for Native Full Ad Dialogs

    await ExoAds.instance.initialize(
      remoteConfig: FirebaseRemoteConfig.instance,
      analytics: FirebaseAnalytics.instance,
      adjustToken: 'vna2du8j320w',
      adjustEventKey: 'g67998',
      isDevMode: kDebugMode,
    );

    await ExoAds.instance.fetchRemoteConfig();
    ExoAds.instance.registerAdsFromRemoteConfig();

    _initialized = true;
    debugPrint('[AdsService] ExoAds initialized.');
  }
}
