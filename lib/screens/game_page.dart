import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/game_controller.dart';
import '../game_engine/tap_dot_game.dart';
import '../widgets/game_hud.dart';
import '../widgets/game_over_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final TapDotGame _game;

  @override
  void initState() {
    super.initState();
    final controller = context.read<GameController>();
    _game = TapDotGame(controller: controller);
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.startGame());
  }

  void _restart() {
    context.read<GameController>().startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          const GameHud(),
          GameOverOverlay(
            onPlayAgain: _restart,
            onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}
