import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/services/ads_logger.dart';
import 'package:app_default/features/no_internet/no_internet_screen.dart';
import 'package:app_default/features/welcome_back/welcome_back_screen.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Service wrapper for ExoAds initialization and lifecycle hooks.
class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  bool _initialized = false;

  /// Lắng nghe các sự kiện của ExoAds (ủy quyền sang AdsLogger)
  void listenToAdEvents() => AdsLogger.instance.listenToAdEvents();

  /// Initialize ExoAds, fetch remote config, and register ads.
  Future<void> initialize() async {
    ExoAds.instance.nativeAdBackgroundColor = AppColors.black;
    // Setup UI for Welcome Back & No Internet Screens
    WelcomeBackScreen.setupStyle();
    NoInternetScreen.setupStyle();

    listenToAdEvents();

    if (_initialized) return;

    ExoAdBase.useNativePlatformFactory = true;
    ExoAds.navigatorKey = Get.key; // REQUIRED for Native Full Ad Dialogs

    await ExoAds.instance.initialize(
      remoteConfig: FirebaseRemoteConfig.instance,
      analytics: FirebaseAnalytics.instance,
      adjustToken: '',
      adjustEventKey: '',
      isDevMode: kDebugMode,
    );

    await ExoAds.instance.fetchRemoteConfig();
    await ExoAds.instance.registerAdsFromRemoteConfig();

    _initialized = true;
    AdsLogger.instance.logToLogcat(
      '[AdsService] ExoAds initialized. adsEnabled: ${ExoAds.instance.adsEnabled}',
    );
    AdsLogger.instance.logToLogcat(
      '[AdsService] Registered ad keys: ${ExoAds.instance.definitions.keys.toList()}',
    );
  }
}
