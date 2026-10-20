import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Cấu hình công tắc bật/tắt quảng cáo cho dự án khi debug/development.
///
/// LƯU Ý BẢO MẬT:
/// - `prod` tuyệt đối KHÔNG cho phép debug hay tắt ads dưới mọi hình thức.
/// - Cờ này chỉ có tác dụng khi chạy flavor `dev`.
class AdsConfig {
  AdsConfig._();

  /// Công tắc cục bộ tắt Ads khi debug.
  static const bool _debugDisableAds = false;

  /// Kiểm tra xem quảng cáo có bị tắt hay không.
  /// Tuyệt đối KHÔNG tắt ads nếu flavor là prod hoặc khi build release.
  static bool get isAdsDisabled {
    // Prod tuyệt đối không được tắt ads
    if (appFlavor == 'prod') {
      return false;
    }

    const fromDefine = bool.fromEnvironment('DISABLE_ADS', defaultValue: false);
    if (fromDefine) return true;

    // Chỉ cho phép tắt trong Debug hoặc Profile mode của flavor dev
    if (kDebugMode || kProfileMode) {
      return _debugDisableAds;
    }

    return false;
  }
}
