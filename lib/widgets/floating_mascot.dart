import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';

/// The player's selected dot skin, gently floating and pulsing on the Home
/// screen so it reads as a game character rather than a static icon.
/// Driven by an [AnimationController] + [AnimatedBuilder] — no setState
/// calls.
class FloatingMascot extends StatefulWidget {
  const FloatingMascot({super.key, this.asset = AssetConstants.dotClassic});

  /// Path relative to `assets/` (see AssetConstants) — defaults to the
  /// classic skin, but Home passes whichever skin is currently equipped.
  final String asset;

  @override
  State<FloatingMascot> createState() => _FloatingMascotState();
}

class _FloatingMascotState extends State<FloatingMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -12 * t),
          child: Transform.scale(scale: 1.0 + 0.05 * t, child: child),
        );
      },
      child: Image.asset(
        AssetConstants.asset(widget.asset),
        width: 150,
        height: 150,
      ),
    );
  }
}
