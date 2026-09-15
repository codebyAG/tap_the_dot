import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../controllers/game_controller.dart';

String _emojiFor(int combo) {
  if (combo >= 50) return '👑';
  if (combo >= 20) return '💥';
  if (combo >= 10) return '⚡';
  if (combo >= 5) return '🔥';
  return '';
}

class ComboWidget extends StatelessWidget {
  const ComboWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final combo = context.select<GameController, int>((c) => c.combo);
    if (combo < 2) return const SizedBox.shrink();

    final emoji = _emojiFor(combo);
    return Text(
      '$emoji COMBO x$combo',
      style: AppTextStyles.combo,
    );
  }
}
