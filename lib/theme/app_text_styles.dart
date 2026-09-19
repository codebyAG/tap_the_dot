import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heroTitle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    height: 1.0,
  );

  static const TextStyle score = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const TextStyle hudLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: 1.2,
  );

  static const TextStyle timer = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const TextStyle combo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );
}
