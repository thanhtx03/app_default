import 'package:app_default/app/bindings/initial_binding.dart';
import 'package:app_default/app/config/app_constants.dart';
import 'package:app_default/app/config/app_theme.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:app_default/app/services/ads_service.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isServicesReady = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      await InitialBinding().initializeServices();
      await AdsService.instance.initialize();
    } catch (e) {
      debugPrint('[SplashScreen] Initialization error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isServicesReady = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isServicesReady) {
      final theme = AppTheme.exoTheme();
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/ic_app.png', width: 88, height: 88),
                      const SizedBox(height: 12),
                      Text(
                        AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: theme.resolvedTitleStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: LinearProgressIndicator(
                    color: theme.primaryColor,
                    backgroundColor: theme.trackColor,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    }

    return ExoSplashView(
      appName: AppConstants.appName,
      theme: AppTheme.exoTheme(),
      logo: Image.asset('assets/icons/ic_app.png', width: 88, height: 88),
      onComplete: () => Get.offNamed(AppRoutes.language),
    );
  }
}