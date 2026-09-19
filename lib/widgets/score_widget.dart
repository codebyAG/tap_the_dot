import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/widgets/hud_chip.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.select<GameController, int>((c) => c.score);
    return HudChip(
      label: 'SCORE',
      value: '$score',
      iconAsset: AssetConstants.iconTrophy,
    );
  }
}
