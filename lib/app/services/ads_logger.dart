import 'dart:async';
import 'dart:developer' as developer;
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/foundation.dart';

/// Class chuyên biệt xử lý lắng nghe sự kiện quảng cáo và ghi log chi tiết cho ExoAds.
class AdsLogger {
  AdsLogger._();

  static final AdsLogger instance = AdsLogger._();

  bool _isListening = false;
  DateTime? _lastInterShowTime;
  final DateTime _appStartTime = DateTime.now();

  StreamSubscription<AdEvent>? _subscription;

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
      intervalStatus =
          'First Inter Ad | App Uptime: ${uptimeSec.toStringAsFixed(1)}s';
    } else {
      final elapsedSec =
          now.difference(_lastInterShowTime!).inMilliseconds / 1000.0;
      if (elapsedSec < betweenSec) {
        final remaining =
            (betweenSec - elapsedSec).clamp(0.0, betweenSec.toDouble());
        intervalStatus =
            'Last Inter: ${elapsedSec.toStringAsFixed(1)}s ago | Cooldown remaining: ${remaining.toStringAsFixed(1)}s ⏳';
      } else {
        intervalStatus =
            'Last Inter: ${elapsedSec.toStringAsFixed(1)}s ago | Interval Passed Ready ✅';
      }
    }

    logToLogcat(
      '⏱️ [INTER INTERVAL] Ad: "${event.adKey}" | Config (between_itval: ${betweenSec}s, start_itval: ${startSec}s) | $intervalStatus',
    );
  }

  /// Lắng nghe các sự kiện của ExoAds và in log tên Ads (adKey) ra Logcat/Console
  void listenToAdEvents() {
    if (_isListening) return;
    _isListening = true;

    _subscription = ExoAds.instance.onEvent.listen((event) {
      final adName = event.adKey;
      final type = event.adUnitType.name;
      final network = event.adNetwork.name;

      switch (event.type) {
        case AdEventType.showed:
          logToLogcat(
            '📺 [ADS SHOWING] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          _logInterIntervalIfNeeded(event);
          if (_isInterAd(event)) {
            _lastInterShowTime = DateTime.now();
          }
          break;
        case AdEventType.impression:
          logToLogcat(
            '👁️ [ADS IMPRESSION] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          break;
        case AdEventType.loaded:
          logToLogcat(
            '✅ [ADS LOADED] Ad Name/Key: "$adName" | Type: $type | Network: $network',
          );
          break;
        case AdEventType.failedToShow:
          logToLogcat(
            '❌ [ADS FAILED TO SHOW] Ad Name/Key: "$adName" | Error: ${event.errorMessage}',
          );
          _logInterIntervalIfNeeded(event);
          break;
        case AdEventType.failedToLoad:
          logToLogcat(
            '⚠️ [ADS FAILED TO LOAD] Ad Name/Key: "$adName" | Error: ${event.errorMessage}',
          );
          break;
        case AdEventType.clicked:
          logToLogcat(
            '👉 [ADS CLICKED] Ad Name/Key: "$adName" | Type: $type',
          );
          break;
        case AdEventType.dismissed:
          logToLogcat(
            '🚪 [ADS DISMISSED] Ad Name/Key: "$adName" | Type: $type',
          );
          break;
        default:
          break;
      }
    });
  }

  /// In thông báo ra debugPrint và logcat
  void logToLogcat(String message) {
    debugPrint(message);
    developer.log(message, name: 'ExoAdsLogcat');
  }

  /// Hủy đăng ký lắng nghe sự kiện
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _isListening = false;
  }
}
