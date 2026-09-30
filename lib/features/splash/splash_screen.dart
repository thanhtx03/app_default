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
      appName: 'App Default',
      theme: AppTheme.exoTheme(),
      logo: const Icon(
        Icons.rocket_launch_rounded,
        size: 88,
        color: Colors.deepPurple,
      ),
      onComplete: () => Get.offNamed(AppRoutes.language),
    );
  }
}
