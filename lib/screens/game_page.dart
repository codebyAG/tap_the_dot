import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/game_engine/tap_dot_game.dart';
import 'package:tap_the_dot/widgets/game_hud.dart';
import 'package:tap_the_dot/widgets/game_over_overlay.dart';
import 'package:tap_the_dot/widgets/pause_overlay.dart';

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

  void _pause() {
    context.read<GameController>().pauseGame();
    _game.pauseEngine();
  }

  void _resume() {
    context.read<GameController>().resumeGame();
    _game.resumeEngine();
  }

  @override
  Widget build(BuildContext context) {
    final isPaused = context.select<GameController, bool>((c) => c.isPaused);

    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          GameHud(onPause: _pause),
          GameOverOverlay(
            onPlayAgain: _restart,
            onHome: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          if (isPaused)
            PauseOverlay(
              onResume: _resume,
              onHome: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
        ],
      ),
    );
  }
}
