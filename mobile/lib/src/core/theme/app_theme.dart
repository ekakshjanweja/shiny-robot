import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/src/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const fontFamily = "Inter Display";

  static AppColors get lightColors => AppColors.light();
  static AppColors get darkColors => AppColors.dark();

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: lightColors.surface,
    textTheme: GoogleFonts.interTextTheme(),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: darkColors.surface,
    textTheme: GoogleFonts.interTextTheme(),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
