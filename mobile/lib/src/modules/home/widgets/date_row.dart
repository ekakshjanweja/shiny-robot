import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/home/widgets/conversations.dart';
import 'package:mobile/src/modules/home/widgets/date_header.dart';
import 'package:mobile/src/modules/home/widgets/date_tab.dart';

class DateRow extends StatefulWidget {
  const DateRow({super.key});

  @override
  State<DateRow> createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  final int daysInMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  ).day;

  late final List<GlobalKey> _itemKeys;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(daysInMonth, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate(selectedDateNotifier.value);
    });

    selectedDateNotifier.addListener(() {
      _scrollToSelectedDate(selectedDateNotifier.value);
    });
  }

  @override
  void dispose() {
    selectedDateNotifier.removeListener(() {});
    selectedDateNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate(DateTime date) {
    final index = date.day - 1;
    if (index < 0 || index >= _itemKeys.length) return;

    final ctx = _itemKeys[index].currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: Duration(milliseconds: 300),
      alignment: 0.5,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Conversations", style: context.textTheme.headline),
        SizedBox(height: 24),

        ValueListenableBuilder<DateTime>(
          valueListenable: selectedDateNotifier,
          builder: (context, selectedDate, _) {
            return SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List<Widget>.generate(daysInMonth, (index) {
                  final date = DateTime(now.year, now.month, index + 1);

                  final isSelected =
                      selectedDate.year == date.year &&
                      selectedDate.month == date.month &&
                      selectedDate.day == date.day;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == daysInMonth - 1 ? 0 : 8,
                    ),
                    child: GestureDetector(
                      key: _itemKeys[index],
                      onTap: () {
                        selectedDateNotifier.value = date;
                      },
                      child: DateTab(date: date, isSelected: isSelected),
                    ),
                  );
                }),
              ),
            );
          },
        ),

        SizedBox(height: 32),
        Column(
          children: [
            ValueListenableBuilder(
              valueListenable: selectedDateNotifier,
              builder: (context, selectedDate, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DateHeader(date: selectedDate),
                    Row(
                      children: [
                        Text(
                          "6",
                          style: context.textTheme.body2.copyWith(
                            color: context.colors.primaryText,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.colors.primaryText,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 16),

            Conversations(),
          ],
        ),
      ],
    );
  }
}
