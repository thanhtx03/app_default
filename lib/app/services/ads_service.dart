import 'package:app_default/app/config/ads_config.dart';
import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/services/ads_logger.dart';
import 'package:app_default/features/no_internet/no_internet_screen.dart';
import 'package:app_default/features/welcome_back/welcome_back_screen.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Service wrapper for ExoAds initialization and lifecycle hooks.
class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  bool _initialized = false;
    /// Lắng nghe các sự kiện của ExoAds (ủy quyền sang AdsLogger)
  void listenToAdEvents() => AdsLogger.instance.listenToAdEvents();

  /// Áp dụng trạng thái bật/tắt ads
  void _applyAdsState() {
    if (AdsConfig.isAdsDisabled) {
      ExoAds.instance.enableAds(false);
      AdsLogger.instance.logToLogcat(
        '🚫 [AdsService] ADS ARE DISABLED: Công tắc tắt ads đang BẬT. Tất cả quảng cáo (Splash, Native, Interstitial, Banner) đã bị tắt.',
      );
    }
  }

  /// Initialize ExoAds, fetch remote config, and register ads.
  Future<void> initialize() async {
    ExoAds.instance.nativeAdBackgroundColor = AppColors.background;
    WelcomeBackScreen.setupStyle();
    NoInternetScreen.setupStyle();
    listenToAdEvents();

    if (_initialized) return;

    ExoAdBase.useNativePlatformFactory = true;
    ExoAds.navigatorKey = Get.key; // REQUIRED for Native Full Ad Dialogs

    try {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
    } catch (e) {
      debugPrint('[AdsService] RemoteConfig setConfigSettings error: $e');
    }

    final isAdsDisabled = AdsConfig.isAdsDisabled;

    // Khởi tạo ExoAds và chờ hoàn tất để đảm bảo SharedPreferences session count được tăng chính xác
    final isProd = appFlavor == 'prod';
    await ExoAds.instance.initialize(
      remoteConfig: FirebaseRemoteConfig.instance,
      analytics: FirebaseAnalytics.instance,
      adjustToken: isProd ? '4x514zi69lhc' : '',
      adjustEventKey: isProd ? 'nbev2g' : '',
      isDevMode: !isProd,
      adsEnabled: !isAdsDisabled,
      onReconnected: () {
        if (AdsConfig.isAdsDisabled) {
          ExoAds.instance.enableAds(false);
        }
      },
    );

    try {
      await ExoAds.instance.fetchRemoteConfig().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('[AdsService] fetchRemoteConfig timed out after 5s');
        },
      );
    } catch (e) {
      debugPrint('[AdsService] fetchRemoteConfig error: $e');
    }

    try {
      await ExoAds.instance.registerAdsFromRemoteConfig();
    } catch (e) {
      debugPrint('[AdsService] registerAdsFromRemoteConfig error: $e');
    }

    _applyAdsState();

    _initialized = true;
    debugPrint('[AdsService] ExoAds initialized. adsEnabled: ${!isAdsDisabled}');
  }
}
