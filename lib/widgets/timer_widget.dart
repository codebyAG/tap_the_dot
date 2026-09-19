import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/widgets/hud_chip.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timeRemaining = context.select<GameController, double>(
      (c) => c.timeRemaining,
    );
    final isLow = timeRemaining <= 5;

    return HudChip(
      label: 'TIME',
      value: timeRemaining.toStringAsFixed(1),
      iconAsset: AssetConstants.iconStopwatch,
      valueColor: isLow ? AppColors.danger : AppColors.textDark,
      alignEnd: true,
      animateChanges: false,
    );
  }
}
