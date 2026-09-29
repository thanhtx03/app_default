import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
class InitialBinding {
  Future<void> initializeServices() async {
    try {
      await Firebase.initializeApp();
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      // Fetch latest Remote Config and register ads
      try {
        final bool updated = await rc.fetchAndActivate();
        debugPrint('[Firebase Remote Config] Connected & Updated from Server: $updated');
        final allKeys = rc.getAll().keys.toList();
        debugPrint('[Firebase Remote Config] Total keys: ${allKeys.length}, Keys: $allKeys');
        for (final key in allKeys) {
          debugPrint('[Firebase Remote Config] Param "$key": ${rc.getString(key)}');
        }
      } catch (e) {
        debugPrint('[Firebase Remote Config] Fetch failed: $e');
      }
    } catch (e) {
      debugPrint('[InitialBinding] Firebase init failed: $e');
    }

  }
}
