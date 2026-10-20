import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:app_default/app/config/feature_colors.dart';

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
      primaryColor: primaryColor ?? FeatureColors.primaryDefault,
      buttonColor: buttonColor ?? FeatureColors.primaryDefault,
      backgroundColor: backgroundColor ?? FeatureColors.backgroundColorDefault,
      textColor: textColor ?? FeatureColors.textColorDefault,
      secondaryTextColor: secondaryTextColor ?? FeatureColors.secondaryTextColorDefault,
      buttonTextColor: buttonTextColor ?? FeatureColors.buttonTextColorDefault,
      adBackgroundColor: FeatureColors.backgroundAdsDefault,
      trackColor: FeatureColors.trackDefault,
    );
  }
}
