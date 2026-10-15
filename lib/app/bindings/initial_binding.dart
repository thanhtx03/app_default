import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
class InitialBinding {
  Future<void> initializeServices() async {
    try {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('[InitialBinding] Firebase init timed out after 5s');
          return Firebase.app();
        },
      );
    } catch (e) {
      debugPrint('[InitialBinding] Firebase init failed: $e');
    }
  }
}
