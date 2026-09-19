import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/game_result.dart';
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
      child: TweenAnimationBuilder<double>(
        key: ValueKey(result.score),
        tween: Tween(begin: 0.85, end: 1.0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
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
                const Text(
                  '🏆 NEW BEST! 🏆',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.gold),
                ),
                const SizedBox(height: 8),
              ] else
                const Text('GAME OVER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 12),
              Text('${result.score}', style: AppTextStyles.heroTitle),
              const SizedBox(height: 4),
              Text('BEST: ${result.bestScore}', style: AppTextStyles.hudLabel),
              const SizedBox(height: 20),
              _StatsPanel(result: result),
              const SizedBox(height: 24),
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
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _StatRow(emoji: '🎯', label: 'Hits', value: '${result.totalHits}'),
          _StatRow(emoji: '💯', label: 'Perfect', value: '${result.perfectHits}'),
          _StatRow(emoji: '🔥', label: 'Best Combo', value: 'x${result.bestCombo}'),
          _StatRow(emoji: '🪙', label: 'Coins', value: '+${result.coinsEarned}'),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.emoji, required this.label, required this.value});

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
