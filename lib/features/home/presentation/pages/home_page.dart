import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/haptic/haptic_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/game_button.dart';
import '../../../game/presentation/controllers/game_controller.dart';
import '../../../game/presentation/pages/game_page.dart';
import '../widgets/floating_mascot.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bestScore = context.select<GameController, int>((c) => c.bestScore);
    final coins = context.select<GameController, int>((c) => c.totalCoins);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: AppColors.background.withValues(alpha: 0.15)),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text(
                  'TAP THE DOT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textLight,
                    height: 1.0,
                    shadows: [
                      Shadow(color: AppColors.primaryDark, offset: Offset(0, 3), blurRadius: 0),
                      Shadow(color: Colors.black26, offset: Offset(0, 6), blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _StatChip(assetPath: 'assets/images/trophy.png', label: '$bestScore'),
                const Spacer(flex: 1),
                const FloatingMascot(),
                const Spacer(flex: 2),
                GameButton(
                  label: 'START GAME',
                  variant: GameButtonVariant.primary,
                  onPressed: () {
                    context.read<HapticService>().buttonTap();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GamePage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _StatChip(assetPath: 'assets/images/coin.png', label: '$coins'),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, width: 22, height: 22),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
