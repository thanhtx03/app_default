import 'package:app_default/app/config/app_theme.dart';
import 'package:app_default/app/config/feature_colors.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return ExoOnboardingView(
      actionTextColor: FeatureColors.actionTextColorDefault,
      indicatorActiveColor: FeatureColors.indicatorActiveColorDefault,
      indicatorInactiveColor: FeatureColors.indicatorInactiveColorDefault,
      theme: AppTheme.exoTheme(
        buttonColor: FeatureColors.buttonColorDefault,
      ),
      pages: [
        ExoOnboardingPage(
          title: 'Title1'.tr,
          description: 'Description1'.tr,
          image: const AssetImage('assets/img_default/intro/intro1.png'),
        ),
        ExoOnboardingPage(
          title: 'Title2'.tr,
          description: 'Description2'.tr,
          image: const AssetImage('assets/img_default/intro/intro2.png'),
        ),
        ExoOnboardingPage(
          title: 'Title3'.tr,
          description: 'Description3'.tr,
          image: const AssetImage('assets/img_default/intro/intro3.png'),
        ),
        ExoOnboardingPage(
          title: 'Title4'.tr,
          description: 'Description4'.tr,
          image: const AssetImage('assets/img_default/intro/intro4.png'),
        ),
      ],
      nextText: 'NEXT'.tr,
      getStartedText: 'GET STARTED'.tr,
      onFinish: () => Get.offNamed(AppRoutes.home),
    );
  }
}
