import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/game_controller.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timeRemaining = context.select<GameController, double>((c) => c.timeRemaining);
    final isLow = timeRemaining <= 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('TIME', style: AppTextStyles.hudLabel),
        Text(
          timeRemaining.toStringAsFixed(1),
          style: AppTextStyles.timer.copyWith(color: isLow ? AppColors.danger : AppColors.textDark),
        ),
      ],
    );
  }
}
