import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;
  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    const weekdays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[date.weekday];
    final month = months[date.month - 1];
    final day = date.day;
    final yearShort = (date.year % 100).toString().padLeft(2, '0');

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: weekday,
            style: context.textTheme.body2.copyWith(
              color: context.colors.primaryText,
            ),
          ),
          TextSpan(
            text: ', $month $day \'$yearShort',
            style: context.textTheme.body2.copyWith(
              color: context.colors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
