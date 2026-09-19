import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';

/// Pill-shaped CTA backed by one of the asset pack's `buttons/button_*.png`
/// sprites (2172x724 — a circular icon badge on the left third, blank
/// space on the right for a label). Sized via [AspectRatio] to the
/// sprite's exact ratio so it's never stretched.
class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.asset,
    required this.onPressed,
  });

  /// One of AssetConstants.buttonPlay/buttonHome/buttonRestart/buttonShop.
  final String asset;
  final String label;
  final VoidCallback onPressed;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  final ValueNotifier<bool> _pressed = ValueNotifier(false);

  @override
  void dispose() {
    _pressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressed.value = true,
      onTapUp: (_) => _pressed.value = false,
      onTapCancel: () => _pressed.value = false,
      onTap: widget.onPressed,
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressed,
        builder: (context, isPressed, child) {
          return AnimatedScale(
            scale: isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: child,
          );
        },
        child: AspectRatio(
          aspectRatio: 2172 / 724,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // The icon badge occupies the left ~1/3 of the sprite — clear
              // it plus a small gutter so the label never overlaps it.
              final badgeWidth = constraints.maxWidth * (724 / 2172);
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AssetConstants.asset(widget.asset),
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: badgeWidth * 1.05,
                      end: constraints.maxWidth * 0.06,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.label,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
