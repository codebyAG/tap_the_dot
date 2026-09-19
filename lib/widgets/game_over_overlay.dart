import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/models/game_result.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'package:tap_the_dot/widgets/game_button.dart';

/// Result card shown over the Flame canvas when a run ends, built on
/// `panels/panel_game_over.png` (trophy ribbon header, one big blank body,
/// one CTA-shaped button) — real content is overlaid in that generous
/// blank body rather than fighting the baked header/button art.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    super.key,
    required this.onPlayAgain,
    required this.onHome,
  });

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
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return AspectRatio(
                    aspectRatio: 1086 / 1448,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AssetConstants.asset(AssetConstants.panelGameOver),
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(flex: 4),
                              Text(
                                result.isNewBest ? 'NEW BEST!' : 'GAME OVER',
                                style: AppTextStyles.hudLabel.copyWith(
                                  fontSize: 16,
                                  color: result.isNewBest
                                      ? AppColors.gold
                                      : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${result.score}',
                                style: AppTextStyles.heroTitle.copyWith(
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'BEST: ${result.bestScore}',
                                style: AppTextStyles.hudLabel,
                              ),
                              const SizedBox(height: 10),
                              _StarRating(result: result),
                              const Spacer(flex: 2),
                              _StatsRow(result: result),
                              const Spacer(flex: 5),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.83),
                          child: SizedBox(
                            width: constraints.maxWidth * 0.62,
                            child: GameButton(
                              label: 'RETRY',
                              asset: AssetConstants.buttonRestart,
                              onPressed: onPlayAgain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onHome,
                child: const Text(
                  'HOME',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.result});

  final GameResult result;

  /// Derived purely from real GameResult fields — no fabricated rating
  /// system. Star 1: landed any hits. Star 2: at least 3 perfect hits.
  /// Star 3: beat the previous best.
  @override
  Widget build(BuildContext context) {
    final stars = [
      result.totalHits > 0,
      result.perfectHits >= 3,
      result.isNewBest,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final filled in stars)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Opacity(
              opacity: filled ? 1.0 : 0.25,
              child: Image.asset(
                AssetConstants.asset(AssetConstants.iconStar),
                width: 22,
                height: 22,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Stat(
          asset: AssetConstants.iconStopwatch,
          value: '${result.totalHits}',
          label: 'Hits',
        ),
        _Stat(
          asset: AssetConstants.iconComboFire,
          value: 'x${result.bestCombo}',
          label: 'Combo',
        ),
        _Stat(
          asset: AssetConstants.iconCoin,
          value: '+${result.coinsEarned}',
          label: 'Coins',
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.asset, required this.value, required this.label});

  final String asset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AssetConstants.asset(asset), width: 22, height: 22),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
        Text(label, style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
      ],
    );
  }
}
