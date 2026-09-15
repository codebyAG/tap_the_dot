import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/haptic/haptic_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../game/presentation/controllers/game_controller.dart';
import '../../../game/presentation/pages/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bestScore = context.select<GameController, int>((c) => c.bestScore);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎯', style: TextStyle(fontSize: 88)),
              const SizedBox(height: 12),
              const Text('TAP THE DOT', style: AppTextStyles.heroTitle, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('BEST: $bestScore', style: AppTextStyles.hudLabel),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  context.read<HapticService>().buttonTap();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GamePage()),
                  );
                },
                child: const Text('START GAME', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
