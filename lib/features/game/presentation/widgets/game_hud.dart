import 'package:flutter/material.dart';

import 'combo_widget.dart';
import 'score_widget.dart';
import 'timer_widget.dart';

/// The Flutter overlay drawn on top of the Flame [GameWidget] — score,
/// timer and combo. Deliberately dumb: all state comes from
/// [GameController] via Provider inside each child widget.
class GameHud extends StatelessWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ScoreWidget(), TimerWidget()],
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
