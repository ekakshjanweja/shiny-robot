import 'package:flutter/material.dart';
import 'package:mobile/src/core/constants/app_assets.dart';
import 'package:mobile/src/core/extensions.dart';

class RecorderButton extends StatelessWidget {
  final VoidCallback onPressed;
  const RecorderButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: context.lightColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: context.colors.card, width: 1),
        ),
        shadows: [
          BoxShadow(
            color: context.colors.surface.withValues(alpha: 0.20),
            blurRadius: 18,
            spreadRadius: -4,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: context.colors.surface.withValues(alpha: 0.06),
            blurRadius: 36,
            spreadRadius: -8,
            offset: Offset(0, 12),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.audioBars, width: 24, height: 24),
              SizedBox(width: 10),
              Text(
                "Record",
                style: context.textTheme.body1.copyWith(
                  color: context.colors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
