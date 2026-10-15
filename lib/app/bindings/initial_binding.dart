import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:app_default/firebase/firebase_options_development.dart' as dev;
import 'package:app_default/firebase/firebase_options_production.dart' as prod;

class InitialBinding {
  Future<void> initializeServices() async {
    try {
      if (appFlavor == 'prod') {
        await Firebase.initializeApp(
          options: prod.DefaultFirebaseOptions.currentPlatform,
        );
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      } else {
        await Firebase.initializeApp(
          options: dev.DefaultFirebaseOptions.currentPlatform,
        );
      }

      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 12),
      ));
      try {
        final updated = await rc.fetchAndActivate();
        if (kDebugMode) {
          debugPrint('[Firebase Remote Config] Fetch & Activate result: $updated');
        }
      } catch (e) {
        // Fallback: Kích hoạt ngay dữ liệu cache đã lưu từ trước nếu offline/mạng chậm
        await rc.activate();
        if (kDebugMode) {
          debugPrint('[Firebase Remote Config] Fetch failed, activated local cache: $e');
        }
      }
      if (kDebugMode) {
        debugPrint('[InitialBinding] Running flavor: $appFlavor');
        debugPrint('[Firebase Remote Config] Initialized successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[InitialBinding] Firebase init failed: $e');
      }
    }
  }
}
