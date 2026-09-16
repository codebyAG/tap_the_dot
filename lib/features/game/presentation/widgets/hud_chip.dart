import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Rounded HUD container shared by score/timer so the gameplay overlay
/// reads as part of the game rather than bare text over the canvas.
class HudChip extends StatelessWidget {
  const HudChip({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textDark,
    this.alignEnd = false,
    this.animateChanges = true,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignEnd;

  /// Pops the value on change — fine for score (changes on hits only),
  /// but must stay off for anything that ticks every frame/100ms (timer).
  final bool animateChanges;

  @override
  Widget build(BuildContext context) {
    final valueText = Text(value, style: AppTextStyles.score.copyWith(color: valueColor));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.hudLabel),
          if (animateChanges)
            TweenAnimationBuilder<double>(
              key: ValueKey(value),
              tween: Tween(begin: 1.15, end: 1.0),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
              child: valueText,
            )
          else
            valueText,
        ],
      ),
    );
  }
}
