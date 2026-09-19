import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/widgets/cartoon_icon_button.dart';
import 'package:tap_the_dot/widgets/combo_widget.dart';
import 'package:tap_the_dot/widgets/score_widget.dart';
import 'package:tap_the_dot/widgets/timer_widget.dart';

/// The Flutter overlay drawn on top of the Flame [GameWidget] — score,
/// timer, combo and a pause control. Deliberately dumb: all state comes
/// from [GameController] via Provider inside each child widget; [onPause]
/// is the only thing GamePage needs to hand down (it also has to pause the
/// Flame engine itself, which lives outside Provider state).
class GameHud extends StatelessWidget {
  const GameHud({super.key, required this.onPause});

  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ScoreWidget(),
                CartoonIconButton(
                  squareAsset: AssetConstants.buttonPause,
                  size: 44,
                  onPressed: onPause,
                ),
                const TimerWidget(),
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: ComboWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
