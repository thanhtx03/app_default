import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
class InitialBinding {
  Future<void> initializeServices() async {
    try {
      await Firebase.initializeApp();
      // Fetch latest Remote Config and register ads
      try {
        final bool updated = await FirebaseRemoteConfig.instance.fetchAndActivate();
        debugPrint('[Firebase Remote Config] Connected & Updated from Server: $updated');
      } catch (e) {
        debugPrint('[Firebase Remote Config] Fetch failed (using local defaults): $e');
      }
    } catch (e) {
      debugPrint('[InitialBinding] Firebase init failed: $e');
    }

  }
}
