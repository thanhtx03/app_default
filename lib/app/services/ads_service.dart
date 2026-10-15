import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/services/ads_logger.dart';
import 'package:app_default/features/no_internet/no_internet_screen.dart';
import 'package:app_default/features/welcome_back/welcome_back_screen.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service wrapper for ExoAds initialization and lifecycle hooks.
class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  bool _initialized = false;

  /// Lắng nghe các sự kiện của ExoAds (ủy quyền sang AdsLogger)
  void listenToAdEvents() => AdsLogger.instance.listenToAdEvents();

  /// Initialize ExoAds, fetch remote config, and register ads.
  Future<void> initialize() async {
    ExoAds.instance.nativeAdBackgroundColor = AppColors.background;
    //ExoAds.instance.nativeAdCtaButtonColor
    // Setup UI for Welcome Back & No Internet Screens
    WelcomeBackScreen.setupStyle();
    NoInternetScreen.setupStyle();

    listenToAdEvents();

    if (_initialized) return;

    ExoAdBase.useNativePlatformFactory = true;
    ExoAds.navigatorKey = Get.key; // REQUIRED for Native Full Ad Dialogs

    final testDevices = [
      'C58E76FBAAB79F4B40A634006766F54B',
    ];

    // Khởi tạo ExoAds và chờ hoàn tất để đảm bảo SharedPreferences session count được tăng chính xác
    await ExoAds.instance.initialize(
      remoteConfig: FirebaseRemoteConfig.instance,
      analytics: FirebaseAnalytics.instance,
      adjustToken: '',
      adjustEventKey: '',
      isDevMode: kDebugMode,
      adsEnabled: true,
      testDeviceIds: testDevices,
      requestConfiguration: RequestConfiguration(testDeviceIds: testDevices),
    );

    // Fetch remote config với timeout 10s để đảm bảo lấy được cấu hình mới nhất
    await ExoAds.instance.fetchRemoteConfig().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (kDebugMode) {
          debugPrint('[AdsService] Remote config fetch timed out after 10s, using cached/defaults.');
        }
      },
    );
    await ExoAds.instance.registerAdsFromRemoteConfig();

    _initialized = true;
    if (kDebugMode) {
      AdsLogger.instance.logToLogcat(
        '[AdsService] ExoAds initialized. Current session: ${ExoAds.instance.appSession}, adsEnabled: ${ExoAds.instance.adsEnabled}',
      );
      AdsLogger.instance.logToLogcat(
        '[AdsService] Registered ad keys: ${ExoAds.instance.definitions.keys.toList()}',
      );
    }
  }
}
