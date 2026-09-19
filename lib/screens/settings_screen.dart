import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/theme/app_text_styles.dart';
import 'package:tap_the_dot/widgets/cartoon_panel.dart';
import 'package:tap_the_dot/widgets/cartoon_toggle.dart';
import 'package:tap_the_dot/widgets/screen_top_bar.dart';

/// Toggles read/write straight through GameController, which applies them
/// to AudioService/HapticService immediately and persists them into
/// PlayerProgress — settings survive an app restart.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetConstants.asset(AssetConstants.backgroundSettings),
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.background.withValues(alpha: 0.15)),
          SafeArea(
            child: Column(
              children: [
                const ScreenTopBar(title: 'SETTINGS'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CartoonPanel(
                    child: Column(
                      children: [
                        _SettingRow(
                          icon: Icons.volume_up_rounded,
                          label: 'Sound Effects',
                          value: controller.soundEnabled,
                          onChanged: (v) => controller.updateSettings(sound: v),
                        ),
                        const Divider(height: 24),
                        _SettingRow(
                          icon: Icons.music_note_rounded,
                          label: 'Music',
                          value: controller.musicEnabled,
                          onChanged: (v) => controller.updateSettings(music: v),
                        ),
                        const Divider(height: 24),
                        _SettingRow(
                          icon: Icons.vibration_rounded,
                          label: 'Haptics',
                          value: controller.hapticsEnabled,
                          onChanged: (v) =>
                              controller.updateSettings(haptics: v),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        CartoonToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
