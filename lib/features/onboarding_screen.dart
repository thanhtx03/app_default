import 'package:app_default/app/config/app_theme.dart';
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
      theme: AppTheme.exoTheme(),
      pages: const [
        ExoOnboardingPage(
          title: 'Title1',
          description:
              'Description1',
          image: AssetImage('assets/images/onboarding_1.png'),
        ),
        ExoOnboardingPage(
          title: 'Title2',
          description:
              'Description2',
          image: AssetImage('assets/images/onboarding_2.png'),
        ),
        ExoOnboardingPage(
          title: 'Title3',
          description:
              'Description3',
          image: AssetImage('assets/images/onboarding_3.png'),
        ),
      ],
      onFinish: () => Get.offNamed(AppRoutes.home),
    );
  }
}
