import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/widgets/reward_card.dart';
import 'package:tap_the_dot/widgets/screen_top_bar.dart';
import 'package:tap_the_dot/widgets/stat_badge.dart';

/// Score-milestone tiers. "Achieved" is derived live from bestScore —
/// there's no separate reward-claim persistence yet, so this reads as a
/// progress list rather than a claimable-rewards inbox.
const _tiers = [
  (score: 50, coins: 20),
  (score: 100, coins: 40),
  (score: 250, coins: 80),
  (score: 500, coins: 150),
  (score: 1000, coins: 300),
];

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bestScore = context.select<GameController, int>((c) => c.bestScore);
    final coins = context.select<GameController, int>((c) => c.totalCoins);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundRewards),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.1)),
          SafeArea(
            child: Column(
              children: [
                ScreenTopBar(
                  title: 'REWARDS',
                  trailing: StatBadge(
                    assetPath: AssetConstants.asset(AssetConstants.iconCoin),
                    label: '$coins',
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: _tiers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tier = _tiers[index];
                      return RewardCard(
                        scoreThreshold: tier.score,
                        coinReward: tier.coins,
                        achieved: bestScore >= tier.score,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
