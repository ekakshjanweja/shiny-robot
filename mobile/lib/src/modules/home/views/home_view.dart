import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/home/widgets/category_row.dart';
import 'package:mobile/src/modules/home/widgets/date_row.dart';
import 'package:mobile/src/modules/home/widgets/home_page_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ).copyWith(top: 64),
      decoration: ShapeDecoration(
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
      ),
      child: Column(
        children: [
          HomePageHeader(),
          SizedBox(height: 32),
          CatergoryRow(),
          SizedBox(height: 32),
          Divider(height: 1, thickness: 1, color: context.colors.card),
          SizedBox(height: 32),
          DateRow(),
        ],
      ),
    );
  }
}
