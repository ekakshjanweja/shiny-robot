import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/src/core/extensions.dart';

class CategoryCard extends StatefulWidget {
  final String icon;
  final String title;

  const CategoryCard({super.key, required this.icon, required this.title});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      onTap: () {
        // Add haptic feedback
        HapticFeedback.lightImpact();
        // Handle card tap
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Tapped on ${widget.title}'),
        //     duration: Duration(milliseconds: 1500),
        //   ),
        // );
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.95 : _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..rotateZ(_isPressed ? 0.1 : 0.0),
                    child: Image.asset(widget.icon, height: 32),
                  ),
                  Text(
                    widget.title,
                    style: context.textTheme.body1.copyWith(
                      color: context.colors.primaryText,
                      fontWeight: _isPressed
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
