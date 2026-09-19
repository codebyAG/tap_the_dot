import 'package:flutter/material.dart';

import 'package:tap_the_dot/theme/app_colors.dart';

/// Rounded, bordered container shared by every screen's content card —
/// the same "cute cartoon" surface treatment (light fill, white border,
/// soft drop shadow) used ad hoc by HudChip/GameOverOverlay, now reusable.
class CartoonPanel extends StatelessWidget {
  const CartoonPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.background,
    this.borderRadius = 24,
    this.border = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double borderRadius;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
