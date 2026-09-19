import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'cartoon_panel.dart';

/// One milestone row on the Rewards screen — "reach this score, earn this
/// many coins". [achieved] is derived purely from the player's existing
/// persisted `bestScore`; there is no reward-claim persistence yet. Uses
/// the trophy icon once earned, the gift icon while still locked — a real
/// distinction, not a tinted duplicate of one asset.
class RewardCard extends StatelessWidget {
  const RewardCard({
    super.key,
    required this.scoreThreshold,
    required this.coinReward,
    required this.achieved,
  });

  final int scoreThreshold;
  final int coinReward;
  final bool achieved;

  @override
  Widget build(BuildContext context) {
    return CartoonPanel(
      color: achieved
          ? AppColors.background
          : AppColors.backgroundAlt.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Image.asset(
            AssetConstants.asset(
              achieved ? AssetConstants.iconTrophy : AssetConstants.iconGift,
            ),
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score $scoreThreshold',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Image.asset(
                      AssetConstants.asset(AssetConstants.iconCoin),
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 4),
                    Text('+$coinReward', style: AppTextStyles.hudLabel),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            achieved ? Icons.check_circle : Icons.lock_rounded,
            color: achieved
                ? AppColors.success
                : AppColors.textDark.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
