import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:app_default/firebase/firebase_options_development.dart' as dev;
import 'package:app_default/firebase/firebase_options_production.dart' as prod;

class InitialBinding {
  Future<void> initializeServices() async {
    // 1. Initialize Firebase
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
    } catch (e) {
      debugPrint('[InitialBinding] Firebase init failed: $e');
    }
  }
}
