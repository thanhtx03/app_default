import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_default/app/bindings/initial_binding.dart';
import 'package:app_default/app/config/app_constants.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:app_default/app/services/ads_logger.dart';
import 'package:app_default/app/services/ads_service.dart';
import 'package:app_default/app/translation/app_translations.dart';

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Tắt toàn bộ log khi chạy app thật (Release), chỉ hiển thị khi Debug
      AdsLogger.setupLogging();

      // Khởi tạo Firebase và các services khác
      await InitialBinding().initializeServices();
      // Khởi tạo Ads Service
      await AdsService.instance.initialize();

      runApp(const MyApp());
    },
    ((error, stack) {
      if (appFlavor == 'prod') {
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
    }),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: AppTranslations.fallbackLocale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorObservers: [
        ExoRouteObserver(),
      ],
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}
