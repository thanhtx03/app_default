import 'package:exo_ads/exo_ads.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  /// Request a permission and return the resulting status.
  static Future<PermissionStatus> requestPermission(
    Permission permission,
  ) async {
    final status = await permission.status;
    if (status.isGranted) return status;
    ExoAds.instance.ignoreNextResume();
    return await permission.request();
  }

  /// Check if a permission is currently granted.
  static Future<bool> isGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Open the app's system settings page.
  static Future<bool> openSettings() async {
    ExoAds.instance.ignoreNextResume();
    return await openAppSettings();
  }
}
