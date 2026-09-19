import 'package:flutter/material.dart';

import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';

/// Small pill showing an asset icon + value — coins, best score/trophy,
/// etc. Generalized from HomePage's old private `_StatChip` so every
/// screen (Home, Shop, Profile, top bars) shares one implementation.
class StatBadge extends StatelessWidget {
  const StatBadge({
    super.key,
    required this.assetPath,
    required this.label,
    this.size = 22,
  });

  final String assetPath;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, width: size, height: size),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
