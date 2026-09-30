import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/config/app_constants.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeBackScreen {
  WelcomeBackScreen._();

  /// Cấu hình các thuộc tính style và giao diện Welcome Back cho ExoAds
  static void setupStyle() {
    ExoAds.instance.welcomeBackLogo = Image.asset(
      'assets/images/icon_app.png',
      width: 50,
      height: 50,
    );
    ExoAds.instance.welcomeBackCenterImage = Image.asset(
      'assets/images/img_welcome_back.png',
      width: 335,
      height: 335,
    );
    // ExoAds.instance.welcomeBackBackgroundColor = AppColors.background;
    ExoAds.instance.welcomeBackAppName = () => AppConstants.appName;
    ExoAds.instance.welcomeBackTitle = () => 'Welcome to our app'.tr;
    ExoAds.instance.welcomeBackText = () => 'Welcome to our app'.tr;
    ExoAds.instance.welcomeBackNextButtonText = () => 'Continue'.tr;
    ExoAds.instance.welcomeBackButtonColor = AppColors.primaryAdsButtonBackground;
    ExoAds.instance.welcomeBackButtonTextColor = AppColors.primaryAdsButtonText;
    ExoAds.instance.welcomeBackButtonMargin =
        const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.welcomeBackButtonPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
  }
}
