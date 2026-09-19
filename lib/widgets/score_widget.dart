import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game_controller.dart';
import 'hud_chip.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.select<GameController, int>((c) => c.score);
    return HudChip(label: 'SCORE', value: '$score');
  }
}
