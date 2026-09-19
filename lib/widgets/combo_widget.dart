import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'package:tap_the_dot/services/game_controller.dart';

class ComboWidget extends StatelessWidget {
  const ComboWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final combo = context.select<GameController, int>((c) => c.combo);
    final multiplier = context.select<GameController, int>(
      (c) => c.comboMultiplier,
    );
    final isFever = context.select<GameController, bool>(
      (c) => c.isFeverActive,
    );

    if (combo < 2) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      key: ValueKey(combo),
      tween: Tween(begin: 1.15, end: 1.0),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isFever ? AppColors.accent : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetConstants.asset(AssetConstants.iconComboFire),
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'x$combo${multiplier > 1 ? '  ·  x$multiplier SCORE' : ''}',
              style: AppTextStyles.combo.copyWith(
                color: isFever ? AppColors.textLight : AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
