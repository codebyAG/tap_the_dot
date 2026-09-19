import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/game_controller.dart';
import 'hud_chip.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timeRemaining = context.select<GameController, double>((c) => c.timeRemaining);
    final isLow = timeRemaining <= 5;

    return HudChip(
      label: 'TIME',
      value: timeRemaining.toStringAsFixed(1),
      valueColor: isLow ? AppColors.danger : AppColors.textDark,
      alignEnd: true,
      animateChanges: false,
    );
  }
}
