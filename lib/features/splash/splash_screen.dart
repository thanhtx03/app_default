import 'package:app_default/app/config/app_constants.dart';
import 'package:app_default/app/config/app_theme.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return ExoSplashView(
      appName: AppConstants.appName,
      theme: AppTheme.exoTheme(),
      logo: Image.asset(
        'assets/icons/ic_app.png',
        width: 88,
        height: 88,
      ),
      onComplete: () => Get.offNamed(AppRoutes.language),
    );
  }
}
