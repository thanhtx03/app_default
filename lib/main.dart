import 'package:app_default/app/config/app_constants.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:app_default/app/services/ads_service.dart';
import 'package:app_default/app/bindings/initial_binding.dart';
import 'package:app_default/app/translation/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase và các services khác
  await InitialBinding().initializeServices();
  // Khởi tạo Ads Service
  await AdsService.instance.initialize();

  runApp(const MyApp());
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
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}
