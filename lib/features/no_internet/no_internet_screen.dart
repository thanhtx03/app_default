import 'package:app_default/app/config/app_colors.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetScreen {
  NoInternetScreen._();

  /// Cấu hình các thuộc tính style và hành vi khi mất kết nối mạng cho ExoAds
  static void setupStyle() {
    ExoAds.instance.noInternetIllustration = Image.asset(
      'assets/img_default/no_internet/img_no_internet.png',
      width: 268,
      height: 268,
    );
    ExoAds.instance.noInternetBackgroundColor = AppColors.backgroundColorDefault;
    ExoAds.instance.noInternetTitle = () => 'No Internet'.tr;
    ExoAds.instance.noInternetTitleColor = AppColors.textColorDefault;
    
    ExoAds.instance.noInternetSubtitle = () => 'No internet connection'.tr;
    ExoAds.instance.noInternetSubtitleColor = AppColors.secondaryTextColorDefault;
    ExoAds.instance.noInternetDescription = () =>
        'No internet connection available due \nto network or service issue'.tr;
    ExoAds.instance.noInternetDescriptionColor = AppColors.secondaryTextColorDefault;
    ExoAds.instance.noInternetRetryLabel = () => 'Try Again'.tr;
    ExoAds.instance.noInternetButtonColor = AppColors.buttonColorDefault;
    ExoAds.instance.noInternetButtonTextColor = AppColors.buttonTextColorDefault;
    ExoAds.instance.noInternetButtonMargin =
        const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.noInternetButtonPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
    ExoAds.instance.onRestartToSplash = () {
      Get.offAllNamed(AppRoutes.splash);
    };
  }
}
