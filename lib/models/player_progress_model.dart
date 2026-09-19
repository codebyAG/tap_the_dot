import 'dart:convert';

import '../../domain/entities/player_progress.dart';

/// JSON (de)serialization for [PlayerProgress]. Kept separate from the
/// domain entity so the domain layer never depends on `dart:convert`
/// or storage-specific concerns.
class PlayerProgressModel extends PlayerProgress {
  const PlayerProgressModel({
    super.bestScore,
    super.coins,
    super.unlockedSkinIds,
    super.selectedSkinId,
    super.soundEnabled,
    super.musicEnabled,
    super.hapticsEnabled,
  });

  factory PlayerProgressModel.fromEntity(PlayerProgress progress) {
    return PlayerProgressModel(
      bestScore: progress.bestScore,
      coins: progress.coins,
      unlockedSkinIds: progress.unlockedSkinIds,
      selectedSkinId: progress.selectedSkinId,
      soundEnabled: progress.soundEnabled,
      musicEnabled: progress.musicEnabled,
      hapticsEnabled: progress.hapticsEnabled,
    );
  }

  factory PlayerProgressModel.fromJson(Map<String, dynamic> json) {
    return PlayerProgressModel(
      bestScore: json['bestScore'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      unlockedSkinIds: (json['unlockedSkinIds'] as List<dynamic>?)?.cast<String>() ?? const ['classic'],
      selectedSkinId: json['selectedSkinId'] as String? ?? 'classic',
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
    );
  }

  factory PlayerProgressModel.fromJsonString(String source) =>
      PlayerProgressModel.fromJson(jsonDecode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'bestScore': bestScore,
    'coins': coins,
    'unlockedSkinIds': unlockedSkinIds,
    'selectedSkinId': selectedSkinId,
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'hapticsEnabled': hapticsEnabled,
  };

  String toJsonString() => jsonEncode(toJson());
}
