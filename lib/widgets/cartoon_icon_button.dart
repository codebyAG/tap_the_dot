import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';

/// Round icon-only button. Three ways to fill the face, in priority order:
/// 1. [squareAsset] — a self-contained circular badge sprite (back/pause/
///    settings buttons, an icon, or a character sprite for the Profile nav
///    avatar) shown as-is via `fit: contain`.
/// 2. [pillAsset] — a wide `button_*.png` pill (play/home/restart/shop),
///    whose icon badge lives in the left square third; cropped out via
///    [Align.widthFactor] rather than guessing pixel coordinates.
/// 3. [icon] — Material icon fallback for actions with no themed sprite.
class CartoonIconButton extends StatelessWidget {
  const CartoonIconButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.squareAsset,
    this.pillAsset,
    this.size = 52,
    this.background = AppColors.background,
    this.iconColor = AppColors.textDark,
  }) : assert(icon != null || squareAsset != null || pillAsset != null);

  final VoidCallback onPressed;
  final IconData? icon;
  final String? squareAsset;
  final String? pillAsset;
  final double size;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 2),
      ),
      elevation: 4,
      shadowColor: Colors.black45,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(padding: const EdgeInsets.all(6), child: _face()),
        ),
      ),
    );
  }

  Widget _face() {
    if (squareAsset != null) {
      return Image.asset(
        AssetConstants.asset(squareAsset!),
        fit: BoxFit.contain,
      );
    }
    if (pillAsset != null) {
      return ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 724 / 2172,
          child: Image.asset(
            AssetConstants.asset(pillAsset!),
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    }
    return Icon(icon, color: iconColor, size: size * 0.5);
  }
}
