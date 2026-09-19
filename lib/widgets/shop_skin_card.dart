import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/models/skin_config.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';

/// One skin tile in the Shop grid, built on `panels/card_shop_item.png` —
/// a template with generous blank zones (sprite circle, name pill, price
/// row, CTA button) rather than tightly-packed baked content, so
/// proportional overlay placement stays safe even if slightly approximate.
class ShopSkinCard extends StatelessWidget {
  const ShopSkinCard({
    super.key,
    required this.skin,
    required this.owned,
    required this.selected,
    required this.affordable,
    required this.onTap,
  });

  final SkinConfig skin;
  final bool owned;
  final bool selected;
  final bool affordable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ctaLabel = selected ? 'EQUIPPED' : (owned ? 'EQUIP' : 'BUY');

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1024 / 1536,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AssetConstants.asset(AssetConstants.cardShopItem),
              fit: BoxFit.fill,
            ),
            FractionallySizedBox(
              alignment: const Alignment(0, -0.62),
              widthFactor: 0.34,
              heightFactor: 0.34,
              child: Opacity(
                opacity: owned ? 1.0 : 0.45,
                child: Image.asset(
                  AssetConstants.asset(skin.asset),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (!owned)
              const FractionallySizedBox(
                alignment: Alignment(0, -0.62),
                widthFactor: 0.16,
                heightFactor: 0.16,
                child: Icon(Icons.lock_rounded, color: AppColors.textDark),
              ),
            if (selected)
              FractionallySizedBox(
                alignment: const Alignment(0.75, -0.85),
                widthFactor: 0.14,
                heightFactor: 0.14,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.gold,
                  shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
                ),
              ),
            Align(
              alignment: const Alignment(0, 0.1),
              child: Text(
                skin.name,
                style: AppTextStyles.hudLabel.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!owned)
              Align(
                alignment: const Alignment(0, 0.36),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetConstants.asset(AssetConstants.iconCoin),
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${skin.price}',
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 12,
                        color: affordable
                            ? AppColors.textDark
                            : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: const Alignment(0, 0.72),
              child: FractionallySizedBox(
                widthFactor: 0.62,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ctaLabel,
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
