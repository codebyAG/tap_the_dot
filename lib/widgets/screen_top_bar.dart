import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'cartoon_icon_button.dart';

/// Shared header for every non-Home, non-Game screen: a back button, a
/// title, and an optional trailing widget (typically a [StatBadge] for
/// coins). Kept separate from the in-run [GameHud], which is a Flame
/// overlay driven by GameController rather than static screen chrome.
class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CartoonIconButton(
            squareAsset: AssetConstants.buttonBack,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.heroTitle.copyWith(fontSize: 26),
            ),
          ),
          if (trailing != null) trailing! else const SizedBox(width: 48),
        ],
      ),
    );
  }
}
