import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/models/skin_config.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/widgets/screen_top_bar.dart';
import 'package:tap_the_dot/widgets/shop_skin_card.dart';
import 'package:tap_the_dot/widgets/stat_badge.dart';

/// Skin gallery. Owned skins can be equipped (persists immediately);
/// locked skins are purchased with earned coins — deducts, unlocks and
/// equips in one step. All state comes from GameController/PlayerProgress,
/// no separate pricing source (see SkinCatalog).
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundShop),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.1)),
          SafeArea(
            child: Column(
              children: [
                ScreenTopBar(
                  title: 'SHOP',
                  trailing: StatBadge(
                    assetPath: AssetConstants.asset(AssetConstants.iconCoin),
                    label: '${controller.totalCoins}',
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 480 ? 3 : 2;
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1024 / 1536,
                        ),
                        itemCount: SkinCatalog.all.length,
                        itemBuilder: (context, index) {
                          final skin = SkinCatalog.all[index];
                          final owned = controller.unlockedSkinIds.contains(
                            skin.id,
                          );
                          final selected = controller.selectedSkinId == skin.id;
                          final affordable =
                              controller.totalCoins >= skin.price;

                          return ShopSkinCard(
                            skin: skin,
                            owned: owned,
                            selected: selected,
                            affordable: affordable,
                            onTap: () => _handleTap(
                              context,
                              controller,
                              skin,
                              owned,
                              affordable,
                            ),
                          );
                        },
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

  void _handleTap(
    BuildContext context,
    GameController controller,
    SkinConfig skin,
    bool owned,
    bool affordable,
  ) {
    if (owned) {
      controller.selectSkin(skin.id);
      return;
    }
    if (!affordable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough coins — need ${skin.price}'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    controller.purchaseSkin(skin.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${skin.name} unlocked!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
