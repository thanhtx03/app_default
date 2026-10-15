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
      'assets/icons/ic_app.png',
      width: 50,
      height: 50,
    );
    ExoAds.instance.welcomeBackCenterImage = Image.asset(
      'assets/img_default/wcb/img_welcome_back.png',
      width: 335,
      height: 335,
    );
    ExoAds.instance.welcomeBackBackgroundColor = AppColors.backgroundColorDefault;
    ExoAds.instance.welcomeBackAppName = () => AppConstants.appName;
    ExoAds.instance.welcomeBackAppNameColor = AppColors.buttonColorDefault;
    ExoAds.instance.welcomeBackTitle = () => 'Welcome back'.tr;
    ExoAds.instance.welcomeBackTitleColor = AppColors.textColorDefault;
    ExoAds.instance.welcomeBackText = () => 'We\'re glad to have you here again. Let\'s pick up \nwhere you left off and continue your journey!'.tr;
    ExoAds.instance.welcomeBackTextColor = AppColors.secondaryTextColorDefault;
    
    ExoAds.instance.welcomeBackNextButtonText = () => 'Continue'.tr;
    ExoAds.instance.welcomeBackButtonColor = AppColors.backgroundColorDefault;
    ExoAds.instance.welcomeBackButtonTextColor = AppColors.buttonColorDefault;
    ExoAds.instance.welcomeBackButtonMargin =
        const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.welcomeBackButtonPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
  }
}
