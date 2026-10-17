import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class InitialBinding {
  Future<void> initializeServices() async {
    // 1. Initialize Firebase directly from Native (google-services.json)
    try {
      await Firebase.initializeApp();

      if (appFlavor == 'prod') {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    } catch (e) {
      debugPrint('[InitialBinding] Firebase init failed: $e');
    }
  }
}
