import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/models/skin_config.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'package:tap_the_dot/widgets/cartoon_panel.dart';
import 'package:tap_the_dot/widgets/screen_top_bar.dart';

/// Shows only real, already-persisted values (bestScore, coins, selected
/// skin, unlocked skin count) — no fabricated stats like "games played"
/// that the data layer doesn't actually track.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final skin = SkinCatalog.byId(controller.selectedSkinId);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundProfile),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.1)),
          SafeArea(
            child: Column(
              children: [
                const ScreenTopBar(title: 'PROFILE'),
                const SizedBox(height: 4),
                // panel_profile_stats.png's nameplate + avatar-circle header
                // is generous/well-isolated, so it's safe to crop to just
                // that top band and drop the player's real skin sprite into
                // the circle — the baked rows further down are skipped in
                // favor of a plain panel with real, live stats below.
                LayoutBuilder(
                  builder: (context, constraints) {
                    final panelWidth = constraints.maxWidth * 0.7;
                    final avatarSize = panelWidth * 0.34;
                    return SizedBox(
                      width: panelWidth,
                      height: panelWidth * (1448 / 1086) * 0.42,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRect(
                            child: Align(
                              alignment: Alignment.topCenter,
                              heightFactor: 0.42,
                              child: Image.asset(
                                AssetConstants.asset(
                                  AssetConstants.panelProfileStats,
                                ),
                                width: panelWidth,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: panelWidth * 0.1),
                            child: ClipOval(
                              child: SizedBox(
                                width: avatarSize,
                                height: avatarSize,
                                child: Image.asset(
                                  AssetConstants.asset(skin.asset),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'PLAYER',
                  style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
                ),
                Text(skin.name, style: AppTextStyles.hudLabel),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CartoonPanel(
                    child: Column(
                      children: [
                        _ProfileStatRow(
                          asset: AssetConstants.iconTrophy,
                          label: 'Best Score',
                          value: '${controller.bestScore}',
                        ),
                        const Divider(height: 24),
                        _ProfileStatRow(
                          asset: AssetConstants.iconCoin,
                          label: 'Coins',
                          value: '${controller.totalCoins}',
                        ),
                        const Divider(height: 24),
                        _ProfileStatRow(
                          asset: AssetConstants.iconStar,
                          label: 'Skins Unlocked',
                          value:
                              '${controller.unlockedSkinIds.length} / ${SkinCatalog.all.length}',
                        ),
                      ],
                    ),
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

class _ProfileStatRow extends StatelessWidget {
  const _ProfileStatRow({
    required this.asset,
    required this.label,
    required this.value,
  });

  final String asset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AssetConstants.asset(asset), width: 28, height: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
