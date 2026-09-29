import 'package:flutter/material.dart';
import 'package:app_default/app/config/app_colors.dart';

/// Typography definitions for s_startup screens
class AppTextTheme {
  AppTextTheme._();

  static const Color _color = AppColors.textPrimary;

  static const TextStyle titleBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.3,
    color: _color,
  );

  static const TextStyle titleSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.4,
    color: _color,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.4,
    color: AppColors.textPrimary,
  );
}
