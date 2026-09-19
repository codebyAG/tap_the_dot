import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/models/skin_config.dart';
import 'package:tap_the_dot/routes.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/services/haptic_service.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/widgets/cartoon_icon_button.dart';
import 'package:tap_the_dot/widgets/floating_mascot.dart';
import 'package:tap_the_dot/widgets/game_button.dart';
import 'package:tap_the_dot/widgets/stat_badge.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bestScore = context.select<GameController, int>((c) => c.bestScore);
    final coins = context.select<GameController, int>((c) => c.totalCoins);
    final selectedSkinId = context.select<GameController, String>(
      (c) => c.selectedSkinId,
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundHome),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.1)),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                LayoutBuilder(
                  builder: (context, constraints) => Image.asset(
                    AssetConstants.asset(AssetConstants.logo),
                    width: constraints.maxWidth * 0.72,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                StatBadge(
                  assetPath: AssetConstants.asset(AssetConstants.iconTrophy),
                  label: '$bestScore',
                ),
                const Spacer(flex: 1),
                FloatingMascot(asset: SkinCatalog.byId(selectedSkinId).asset),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GameButton(
                    label: 'START GAME',
                    asset: AssetConstants.buttonPlay,
                    onPressed: () {
                      context.read<HapticService>().buttonTap();
                      Navigator.of(context).pushNamed(AppRoutes.game);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartoonIconButton(
                      pillAsset: AssetConstants.buttonShop,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.shop),
                    ),
                    const SizedBox(width: 16),
                    CartoonIconButton(
                      squareAsset: AssetConstants.iconGift,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.rewards),
                    ),
                    const SizedBox(width: 16),
                    CartoonIconButton(
                      squareAsset: SkinCatalog.byId(selectedSkinId).asset,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.profile),
                    ),
                    const SizedBox(width: 16),
                    CartoonIconButton(
                      squareAsset: AssetConstants.buttonSettings,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.settings),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StatBadge(
                  assetPath: AssetConstants.asset(AssetConstants.iconCoin),
                  label: '$coins',
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
