import 'package:app_default/views/home_screen.dart';
import 'package:app_default/features/language_screen.dart';
import 'package:app_default/features/onboarding_screen.dart';
import 'package:app_default/features/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.language: (context) => const LanguageScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
};
