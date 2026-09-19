import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum GameButtonVariant { primary, secondary }

/// Chunky, 3D "game UI" button — a lighter top face sitting on a darker
/// base, which shifts down to meet the base on press. Deliberately not a
/// plain [ElevatedButton]; Material's flat ripple doesn't read as a
/// casual-game CTA. Press state is a [ValueNotifier] driving
/// [ValueListenableBuilder] rather than setState.
class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = GameButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final GameButtonVariant variant;
  final IconData? icon;

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
    final isPrimary = widget.variant == GameButtonVariant.primary;
    final topColor = isPrimary ? AppColors.primary : AppColors.background;
    final baseColor = isPrimary ? AppColors.primaryDark : AppColors.backgroundAlt;
    final textColor = isPrimary ? AppColors.textLight : AppColors.textDark;
    final depth = isPrimary ? 6.0 : 4.0;
    final radius = isPrimary ? 28.0 : 20.0;
    final hPad = isPrimary ? 40.0 : 22.0;
    final vPad = isPrimary ? 18.0 : 12.0;

    return GestureDetector(
      onTapDown: (_) => _pressed.value = true,
      onTapUp: (_) => _pressed.value = false,
      onTapCancel: () => _pressed.value = false,
      onTap: widget.onPressed,
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressed,
        builder: (context, isPressed, child) {
          return Padding(
            padding: EdgeInsets.only(bottom: depth),
            child: Stack(
              children: [
                Positioned.fill(
                  top: depth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(radius)),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(top: isPressed ? depth : 0),
                  child: child,
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.lerp(topColor, Colors.white, 0.18)!, topColor],
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: textColor, size: isPrimary ? 22 : 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: isPrimary
                    ? AppTextStyles.button
                    : AppTextStyles.button.copyWith(fontSize: 14, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
