import 'package:flutter/material.dart';
import 'package:mobile/src/core/theme/app_text_theme.dart';
import 'package:mobile/src/core/theme/app_colors.dart';

extension ThemeX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  AppColors get colors => isDarkMode ? AppColors.dark() : AppColors.light();
  AppColors get lightColors => AppColors.light();
  AppColors get darkColors => AppColors.dark();
  AppColors get invertedColors =>
      isDarkMode ? AppColors.light() : AppColors.dark();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  AppTextTheme get textTheme => AppTextTheme.fromColors(colors);
}

extension SizeX on BuildContext {
  double get h => MediaQuery.of(this).size.height;
  double get w => MediaQuery.of(this).size.width;
  bool get isSmallSized => MediaQuery.of(this).size.height < 700;
}
