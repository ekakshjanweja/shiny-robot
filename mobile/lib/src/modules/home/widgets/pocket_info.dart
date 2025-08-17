import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/src/core/constants/app_assets.dart';
import 'package:mobile/src/core/extensions.dart';

class PocketInfo extends StatelessWidget {
  const PocketInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppAssets.pocketLogo, height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ekaksh's Pocket",
                  style: context.textTheme.body1.copyWith(
                    color: context.darkColors.primaryText,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      "Connected",
                      style: context.textTheme.body2.copyWith(
                        color: context.darkColors.success,
                      ),
                    ),
                    Text(
                      "· 75%",
                      style: context.textTheme.body2.copyWith(
                        color: context.darkColors.secondaryText,
                      ),
                    ),
                    SvgPicture.asset(AppAssets.battery, height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
