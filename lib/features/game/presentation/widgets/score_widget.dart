import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../controllers/game_controller.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.select<GameController, int>((c) => c.score);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SCORE', style: AppTextStyles.hudLabel),
        Text('$score', style: AppTextStyles.score),
      ],
    );
  }
}
