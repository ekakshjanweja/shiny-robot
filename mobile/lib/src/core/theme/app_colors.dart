import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  final Color primaryText;
  final Color secondaryText;
  final Color surface;
  final Color card;
  final Color success;
  final Color highlight;

  AppColors({
    required this.primaryText,
    required this.secondaryText,
    required this.surface,
    required this.card,
    required this.success,
    required this.highlight,
  });

  factory AppColors.light() {
    return AppColors(
      primaryText: Color(0xFF000000),
      secondaryText: const Color(0x80000000),
      surface: const Color(0xFFFFFFFF),
      card: Colors.black.withValues(alpha: 0.05),
      success: const Color(0xFF30D158),
      highlight: const Color(0xFFFF9500),
    );
  }

  factory AppColors.dark() {
    return AppColors(
      primaryText: const Color(0xFFFFFFFF),
      secondaryText: const Color(0x80FFFFFF),
      surface: const Color(0xFF000000),
      card: Colors.white.withValues(alpha: 0.05),
      success: const Color(0xFF30D158),
      highlight: const Color(0xFFFF9500),
    );
  }
}
