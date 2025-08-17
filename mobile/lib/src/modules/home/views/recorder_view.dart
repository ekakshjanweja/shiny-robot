import 'package:flutter/material.dart';
import 'package:mobile/src/core/audio/providers/audio_service_provider.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/home/widgets/pocket_info.dart';
import 'package:mobile/src/modules/home/widgets/recorder_button.dart';
import 'package:mobile/src/modules/recorder/ui/recorder_page.dart';
import 'package:provider/provider.dart';

class RecordingView extends StatefulWidget {
  final VoidCallback onVerticalDragDown;
  final VoidCallback onVerticalDragUp;
  const RecordingView({
    super.key,
    required this.onVerticalDragDown,
    required this.onVerticalDragUp,
  });

  @override
  State<RecordingView> createState() => _RecordingViewState();
}

class _RecordingViewState extends State<RecordingView> {
  final ValueNotifier<bool> swipeNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    swipeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w,
      color: context.darkColors.surface,
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                widget.onVerticalDragDown();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                spacing: 24,
                children: [
                  Container(
                    height: 4,
                    width: 32,
                    decoration: ShapeDecoration(
                      color: context.darkColors.secondaryText,
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PocketInfo(),
                      RecorderButton(onPressed: widget.onVerticalDragDown),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            width: context.w,
            height: context.h,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      widget.onVerticalDragUp();
                      final asp = context.read<AudioServiceProvider>();
                      asp.reset();
                    }
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 24),
                    width: context.w,
                    height: 132,
                    decoration: ShapeDecoration(
                      color: context.colors.surface,
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      "Swipe down to go to home",
                      style: context.textTheme.headline,
                    ),
                  ),
                ),
                Expanded(child: RecorderPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
