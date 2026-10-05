import 'package:flutter/foundation.dart';

/// Cấu hình công tắc bật/tắt quảng cáo cho dự án khi debug/development.
///
/// Các cách sử dụng:
/// 1. Dùng lệnh Terminal:
///    - Tắt ads: `./ads off` (hoặc `dart run scripts/ads.dart off`)
///    - Bật ads: `./ads on` (hoặc `dart run scripts/ads.dart on`)
///    - Kiểm tra trạng thái: `./ads status` (hoặc `dart run scripts/ads.dart status`)
/// 2. Chạy trực tiếp qua Flutter CLI:
///    - `flutter run --dart-define=DISABLE_ADS=true` (hoặc `./ads run`)
/// 3. Thay đổi trực tiếp biến [_debugDisableAds] bên dưới.
class AdsConfig {
  AdsConfig._();

  /// Công tắc cục bộ tắt Ads khi debug (được thay đổi tự động bởi script terminal).
  static const bool _debugDisableAds = true;

  /// Kiểm tra xem quảng cáo có bị tắt hay không.
  /// Ưu tiên:
  /// 1. Biến môi trường `--dart-define=DISABLE_ADS=true` khi chạy flutter run / build.
  /// 2. Công tắc cục bộ [_debugDisableAds] (chỉ áp dụng khi debug/profile mode để đảm bảo an toàn cho release).
  static bool get isAdsDisabled {
    const fromDefine = bool.fromEnvironment('DISABLE_ADS', defaultValue: false);
    if (fromDefine) return true;

    // Chỉ tắt trong Debug hoặc Profile mode. Release mode vẫn an toàn và không bị ảnh hưởng ngoài ý muốn.
    if (kDebugMode || kProfileMode) {
      return _debugDisableAds;
    }

    return false;
  }
}
