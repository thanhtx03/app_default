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
      'assets/images/img_no_internet.png',
      width: 268,
      height: 268,
    );
    ExoAds.instance.noInternetBackgroundColor = AppColors.background;
    ExoAds.instance.noInternetTitle = () => 'No Internet'.tr;
    ExoAds.instance.noInternetSubtitle = () => 'No internet connection'.tr;
    ExoAds.instance.noInternetDescription = () =>
        'No internet connection available due \nto network or service issue'.tr;
    ExoAds.instance.noInternetRetryLabel = () => 'Try Again'.tr;
    ExoAds.instance.noInternetButtonColor = AppColors.primary;
    ExoAds.instance.noInternetButtonTextColor = AppColors.textPrimary;
    ExoAds.instance.noInternetButtonMargin =
        const EdgeInsets.symmetric(horizontal: 48);
    ExoAds.instance.noInternetButtonPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
    ExoAds.instance.onRestartToSplash = () {
      Get.offAllNamed(AppRoutes.splash);
    };
  }
}
