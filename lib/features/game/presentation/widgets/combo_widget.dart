import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/game_controller.dart';

String _emojiFor(int combo) {
  if (combo >= 30) return '👑';
  if (combo >= 20) return '💥';
  if (combo >= 10) return '⚡';
  if (combo >= 5) return '🔥';
  return '🔥';
}

class ComboWidget extends StatelessWidget {
  const ComboWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final combo = context.select<GameController, int>((c) => c.combo);
    final multiplier = context.select<GameController, int>((c) => c.comboMultiplier);
    final isFever = context.select<GameController, bool>((c) => c.isFeverActive);

    if (combo < 2) return const SizedBox.shrink();

    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 120),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isFever ? AppColors.accent : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: Text(
              '${_emojiFor(combo)} x$combo${multiplier > 1 ? '  ·  x$multiplier SCORE' : ''}',
              style: AppTextStyles.combo.copyWith(color: isFever ? AppColors.textLight : AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
