import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle logoText = TextStyle(
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 30,
    color: AppColors.secondary,
    shadows: [
      Shadow(offset: Offset(2, 2), blurRadius: 4, color: AppColors.shadowDark),
    ],
  );

  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonWhite = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle buttonWhiteLarge = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle greyLabel = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.grey,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle welcomeText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static const TextStyle welcomeName = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle menuItemLabel = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static const TextStyle tagText = TextStyle(
    fontSize: 8,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelBold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle formButton = TextStyle(
    color: AppColors.primary,
  );

  static const TextStyle logoutText = TextStyle(
    color: AppColors.error,
    fontWeight: FontWeight.bold,
  );
}
