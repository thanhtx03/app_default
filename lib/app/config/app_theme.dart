import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:app_default/app/config/app_colors.dart';

/// Theme builder for s_startup screens
class AppTheme {
  AppTheme._();

  /// Build standard ExoScreenTheme for ExoSplashView, ExoLanguageView, ExoOnboardingView
  static ExoScreenTheme exoTheme({
    Color? primaryColor,
    Color? buttonColor,
    Color? backgroundColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? buttonTextColor,
  }) 
  {
    return ExoScreenTheme(
      primaryColor: primaryColor ?? AppColors.primaryDefault,
      buttonColor: buttonColor ?? AppColors.primaryDefault,
      backgroundColor: backgroundColor ?? AppColors.backgroundColorDefault,
      textColor: textColor ?? AppColors.textColorDefault,
      secondaryTextColor: secondaryTextColor ?? AppColors.secondaryTextColorDefault,
      buttonTextColor: buttonTextColor ?? AppColors.buttonTextColorDefault,
      adBackgroundColor: AppColors.backgroundAdsDefault,
      trackColor: AppColors.trackDefault,
    );
  }
}
