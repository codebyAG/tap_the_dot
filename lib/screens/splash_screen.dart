import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/routes.dart';
import 'package:tap_the_dot/theme/app_colors.dart';

/// First screen shown on launch — brand moment only, no gameplay or data
/// loading gate (GameController already loads progress on its own in the
/// background). Auto-advances to Home after a short beat.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundHome),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.1)),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: Tween(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final logoWidth = constraints.maxWidth * 0.75;
                      return Image.asset(
                        AssetConstants.asset(AssetConstants.logo),
                        width: logoWidth,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
