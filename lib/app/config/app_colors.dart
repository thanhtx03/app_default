import 'package:flutter/material.dart';

/// Colors specific to startup screens (Splash, Language, Intro, WCB, No Internet)
/// Extracted from reskin-movie_tv_show theme
class AppColors {
  AppColors._();
  
  // Ads Colors
  static const Color textPrimaryAds = Color(0xFFFFFFFF);
  static const Color primaryAdsButton = Color(0xFF00BFFF); 
  static const Color primaryAdsButtonText = Color(0xFF00BFFF); 
  static const Color primaryAdsButtonBackground = Color(0xFF000000);
  static const Color backgroundAds = Color(0xFF050505);  

  // Primary Colors (Neon Blue - Cyberpunk & Immersive from reskin-movie_tv_show)
  static const Color primary = Color(0xFF00BFFF); // Neon Blue
  static const Color primaryLight = Color(0xFF66D9FF);
  static const Color primaryDark = Color(0xFF0099CC);
  static const Color primaryTransparent = Color(0x00000000);
  static const Color black = Color(0x00000000); // 36% White


  // Background & Surface Colors (Deep Black for maximum contrast)
  static const Color background = Color(0xFF050505); // Deep Black
  static const Color surface = Color(0xFF141414);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF1A1A1A);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textBody = Color(0xFFE0E0E0);

  // Ads Background Color
  static const Color bgAds = Color(0xFF303030);

  // Status & Track Colors
  static const Color error = Color(0xFFD50000);
  static const Color track = Color(0xFF3A3A3C);
}
