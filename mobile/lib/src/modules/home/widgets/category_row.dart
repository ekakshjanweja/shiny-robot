import 'package:flutter/material.dart';
import 'package:mobile/src/core/constants/app_assets.dart';
import 'package:mobile/src/modules/home/widgets/catergory_card.dart';

class CatergoryRow extends StatefulWidget {
  const CatergoryRow({super.key});

  @override
  State<CatergoryRow> createState() => _CatergoryRowState();
}

class _CatergoryRowState extends State<CatergoryRow>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  final List<Map<String, String>> _items = [
    {'icon': AppAssets.folderThumb3, 'title': 'Meetings'},
    {'icon': AppAssets.folderThumb2, 'title': 'Projects'},
    {'icon': AppAssets.folderThumb1, 'title': 'Documents'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Start the entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Row(
            spacing: 16,
            children: List.generate(_items.length, (index) {
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index * 0.1).clamp(0.0, 1.0),
                    ((index * 0.1) + 0.7).clamp(0.0, 1.0),
                    curve: Curves.easeOutBack,
                  ),
                ),
              );

              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final v = animation.value.clamp(0.0, 1.0);

                  return Transform.scale(
                    scale: 0.3 + (0.7 * v),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: Opacity(
                        opacity: v,
                        child: CategoryCard(
                          icon: _items[index]['icon']!,
                          title: _items[index]['title']!,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
