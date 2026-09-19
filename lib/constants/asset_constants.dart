/// Paths to imported assets. Referenced by [AudioService] and skin lookups.
///
/// Only 4 of the 8 planned sound effects have been imported so far
/// (tap/perfect/coin/bomb) — see the mapping note in [AudioService].
class AssetConstants {
  AssetConstants._();

  static const String imagesPath = 'assets/images';
  static const String audioPath = 'assets/audio';

  // Flame's default image cache prefix is 'assets/images/', so components
  // reference these by file name only (e.g. images.fromCache(dotClassic)).
  static const String dotClassic = 'dot_classic.png';
  static const String dotNeon = 'dot_neon.png';
  static const String dotFire = 'dot_fire.png';
  static const String dotIce = 'dot_ice.png';
  static const String dotCandy = 'dot_candy.png';
  static const String dotRainbow = 'dot_rainbow.png';
  static const String bomb = 'bomb.png';
  static const String coin = 'coin.png';
  static const String trophy = 'trophy.png';
  static const String background = 'background.png';
  static const String softGlow = 'soft_glow.png';

  // Imported so far:
  static const String sfxTap = 'tap_sound.mp3';
  static const String sfxSuccess = 'success_sound.mp3';
  static const String sfxCoin = 'coin_collect.mp3';
  static const String sfxBomb = 'bomb_explode.mp3';

  // Not imported yet — filenames are the expected names from the design
  // spec, kept here so AudioService fails soft (no-op) instead of crashing
  // once these are wired up.
  static const String sfxCombo = 'combo.wav';
  static const String sfxGameOver = 'game_over.wav';
  static const String sfxNewBest = 'new_best.wav';
  static const String sfxButton = 'button.wav';
}
