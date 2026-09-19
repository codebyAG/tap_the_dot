import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';

/// Toggle switch built from `buttons/toggle_on_off.png` — a single sprite
/// sheet with the "ON" (green) frame on the left half and "OFF" (grey)
/// frame on the right half, each exactly half the image width. Cropped via
/// [Align.widthFactor] rather than two separate asset files.
class CartoonToggle extends StatelessWidget {
  const CartoonToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 76,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    // Sprite sheet is 2172x724 total, i.e. each 1086x724 frame is ~1.5:1.
    final height = width * (724 / 1086);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: Align(
            alignment: value ? Alignment.centerLeft : Alignment.centerRight,
            widthFactor: 0.5,
            child: Image.asset(
              AssetConstants.asset(AssetConstants.toggleOnOff),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
