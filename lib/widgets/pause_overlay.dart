import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'package:tap_the_dot/widgets/cartoon_panel.dart';
import 'package:tap_the_dot/widgets/game_button.dart';

/// Shown when [GameController.isPaused] — freezes the run without
/// resetting it. Resume uses the "play" sprite (same visual language as
/// Start), Home exits back to the main menu.
class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.onResume, required this.onHome});

  final VoidCallback onResume;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: CartoonPanel(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAUSED',
                style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 24),
              GameButton(
                label: 'RESUME',
                asset: AssetConstants.buttonPlay,
                onPressed: onResume,
              ),
              const SizedBox(height: 12),
              GameButton(
                label: 'HOME',
                asset: AssetConstants.buttonHome,
                onPressed: onHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
