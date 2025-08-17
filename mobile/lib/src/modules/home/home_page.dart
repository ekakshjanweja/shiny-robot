import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/home/views/home_view.dart';
import 'package:mobile/src/modules/home/views/recorder_view.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> swipeNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    swipeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.darkColors.surface,
      body: ValueListenableBuilder(
        valueListenable: swipeNotifier,
        builder: (context, swipe, _) {
          return SingleChildScrollView(
            controller: scrollController,
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeView(),
                RecordingView(
                  onVerticalDragDown: () {
                    swipeNotifier.value = true;
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  onVerticalDragUp: () {
                    swipeNotifier.value = false;
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
