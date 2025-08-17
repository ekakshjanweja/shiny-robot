import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/constants/app_assets.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/auth/providers/auth_provider.dart';
import 'package:mobile/src/modules/auth/ui/auth_page.dart';
import 'package:provider/provider.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pocket', style: context.textTheme.title1),
            Consumer<AuthProvider>(
              builder: (context, ap, _) {
                return Text(
                  'Good morning, ${(() {
                    final n = ap.user?.name ?? 'Guest';
                    return n.isEmpty ? n : '${n[0].toUpperCase()}${n.substring(1)}';
                  })()}',
                  style: context.textTheme.body2,
                );
              },
            ),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppAssets.search, width: 16, height: 16),
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 9.5, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  context.colors.card,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                AppAssets.circleUser,
                width: 16,
                height: 16,
              ),
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 9.5, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  context.colors.card,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final ap = context.read<AuthProvider>();
                final error = await ap.signOut();

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: ${error.message}'),
                    ),
                  );
                  return;
                }

                context.go(AuthPage.routeName);
              },
              icon: Icon(Icons.logout, size: 16),
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 9.5, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  context.colors.card,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
