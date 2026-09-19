import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';

enum SoundEffect {
  tap,
  perfect,
  combo,
  coin,
  bomb,
  gameOver,
  newBest,
  button,
  miss,
}

// Only tap/coin/bomb/success have been imported so far. Perfect, combo and
// new-best all borrow the "success" sting until dedicated effects arrive;
// game-over, button and miss are left unmapped (play() silently no-ops for
// them) rather than reusing a sound that would feel wrong — the wrong-tap
// spec explicitly wants a soft, non-harsh miss sound we don't have yet.
const Map<SoundEffect, String> _soundFiles = {
  SoundEffect.tap: AssetConstants.sfxTap,
  SoundEffect.perfect: AssetConstants.sfxSuccess,
  SoundEffect.combo: AssetConstants.sfxSuccess,
  SoundEffect.coin: AssetConstants.sfxCoin,
  SoundEffect.bomb: AssetConstants.sfxBomb,
  SoundEffect.newBest: AssetConstants.sfxSuccess,
};

/// Plays short sound effects. Uses a small pool of [AudioPlayer]s so
/// overlapping hits (e.g. combo sounds) don't cut each other off.
///
/// Missing/unimported audio assets are swallowed rather than thrown —
/// gameplay must never crash because a sound file hasn't been added yet.
class AudioService {
  AudioService({int poolSize = 4})
    : _players = List.generate(
        poolSize,
        (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
      );

  final List<AudioPlayer> _players;
  int _nextPlayer = 0;

  bool sfxEnabled = true;
  bool musicEnabled = true;

  Future<void> play(SoundEffect effect) async {
    if (!sfxEnabled) return;
    final fileName = _soundFiles[effect];
    if (fileName == null) return;

    final player = _players[_nextPlayer];
    _nextPlayer = (_nextPlayer + 1) % _players.length;

    try {
      await player.play(AssetSource('audio/$fileName'));
    } catch (error) {
      debugPrint('AudioService: could not play "$fileName" — $error');
    }
  }

  void dispose() {
    for (final player in _players) {
      player.dispose();
    }
  }
}
