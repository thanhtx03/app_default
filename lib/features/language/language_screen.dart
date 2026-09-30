import 'package:app_default/app/config/app_theme.dart';
import 'package:app_default/app/routes/app_routes.dart';
import 'package:exo_ads/exo_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return ExoLanguageView(
      title: 'Language'.tr,
      theme: AppTheme.exoTheme(),
      initialSelectedCode: const Locale('en', 'US'),
      languages: exoDefaultLanguageOptions
          .where((option) => option.locale.languageCode != 'vi')
          .toList(),
      onSubmit: (selected) {
        Get.updateLocale(selected.locale);
        Get.offNamed(AppRoutes.onboarding);
      },
    );
  }
}
