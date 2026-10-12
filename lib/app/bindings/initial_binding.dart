import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
class InitialBinding {
  Future<void> initializeServices() async {
    try {
      await Firebase.initializeApp();
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 12),
      ));
      // Kích hoạt ngay dữ liệu cache đã lưu từ trước (tức thời 0ms, không chờ mạng)
      await rc.activate();
      if (kDebugMode) {
        debugPrint('[Firebase Remote Config] Initialized & Activated local cache.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[InitialBinding] Firebase init failed: $e');
      }
    }
  }
}
