import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:app_default/app/config/app_colors.dart';

/// Theme builder for s_startup screens
class SStartupTheme {
  SStartupTheme._();

  /// Build standard ExoScreenTheme for ExoSplashView, ExoLanguageView, ExoOnboardingView
  static ExoScreenTheme exoTheme({
    Color? primaryColor,
    Color? buttonColor,
    Color? backgroundColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? buttonTextColor,
  }) {
    return ExoScreenTheme(
      primaryColor: primaryColor ?? AppColors.primary,
      buttonColor: buttonColor ?? AppColors.primary,
      backgroundColor: backgroundColor ?? AppColors.background,
      textColor: textColor ?? AppColors.textPrimary,
      secondaryTextColor: secondaryTextColor ?? AppColors.textSecondary,
      buttonTextColor: buttonTextColor ?? AppColors.textPrimary,
      adBackgroundColor: AppColors.bgAds,
      trackColor: AppColors.track,
    );
  }
}
