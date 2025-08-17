import 'package:flutter/widgets.dart';
import 'package:mobile/src/core/theme/app_colors.dart';

class AppTextTheme {
  final TextStyle title1;
  final TextStyle headline;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle subtext1;

  AppTextTheme({
    required this.title1,
    required this.headline,
    required this.body1,
    required this.body2,
    required this.subtext1,
  });

  factory AppTextTheme.fromColors(AppColors colors) {
    final fontFamily = "Inter Display";

    return AppTextTheme(
      title1: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 37 / 28,
        letterSpacing: 0.38,
        color: colors.primaryText,
      ),
      headline: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 1.0,
        letterSpacing: 0.2,
        color: colors.primaryText,
      ),
      body1: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 15,
        height: 24 / 15,
        letterSpacing: 0.4,
        color: colors.primaryText,
      ),
      body2: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        height: 20 / 13,
        letterSpacing: 0.4,
        color: colors.secondaryText,
      ),
      subtext1: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.0,
        letterSpacing: 0.2,
        color: colors.secondaryText,
      ),
    );
  }
}
