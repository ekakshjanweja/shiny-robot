import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';

class DateTab extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  const DateTab({super.key, required this.date, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? context.colors.card : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            date.day.toString(),
            style: context.textTheme.headline.copyWith(
              color: isSelected
                  ? context.colors.primaryText
                  : context.colors.secondaryText,
            ),
          ),
          SizedBox(height: 4),
          Text(
            isSelected
                ? [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ][date.weekday - 1]
                : [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ][date.weekday - 1][0],
            style: context.textTheme.subtext1.copyWith(
              color: isSelected
                  ? context.colors.highlight
                  : context.colors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
