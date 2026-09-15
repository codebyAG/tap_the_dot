import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/game_controller.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.onPlayAgain, required this.onHome});

  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final result = controller.lastResult;
    if (result == null) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (result.isNewBest) ...[
              const Text('🎉 NEW BEST! 🎉', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.gold)),
              const SizedBox(height: 8),
            ] else
              const Text('GAME OVER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 16),
            Text('${result.score}', style: AppTextStyles.heroTitle),
            const SizedBox(height: 4),
            Text('BEST: ${result.bestScore}', style: AppTextStyles.hudLabel),
            if (result.coinsEarned > 0) ...[
              const SizedBox(height: 8),
              Text('🪙 +${result.coinsEarned} coins', style: AppTextStyles.body),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPlayAgain,
                child: const Text('PLAY AGAIN', style: AppTextStyles.button),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onHome,
              child: const Text('HOME', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
