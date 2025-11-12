import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Font Family
  static const String primaryFontFamily = 'Fredroka';
  static const String secondaryFontFamily = 'Ninuto';

  // Light Theme Text Styles
  static const TextTheme textTheme = TextTheme(
    // Display Styles
    displayLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
      height: 1.2,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.3,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      height: 1.4,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackground,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackground,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackground,
      height: 1.5,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackground,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackground,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackground,
      height: 1.4,
    ),
  );

  // Dark Theme Text Styles
  static const TextTheme textThemeDark = TextTheme(
    // Display Styles
    displayLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackgroundDark,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackgroundDark,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackgroundDark,
      height: 1.2,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.3,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackgroundDark,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackgroundDark,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.onBackgroundDark,
      height: 1.5,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontFamily: secondaryFontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackgroundDark,
      height: 1.4,
    ),
  );

  // Custom Text Styles
  static const TextStyle buttonText = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  static const TextStyle successText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.success,
  );

  static const TextStyle warningText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.warning,
  );

  static const TextStyle infoText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.info,
  );

  static const TextStyle hintText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  static const TextStyle captionText = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}
