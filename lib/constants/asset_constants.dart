/// Paths to imported assets, grouped by the asset-pack's own folder
/// categories (branding/buttons/characters/panels/icons/backgrounds/hud/
/// effects/audio — see assets/ on disk).
///
/// Image paths here are relative to `assets/` WITHOUT the `assets/` prefix
/// itself — that matches Flame's `Images` cache convention (components
/// look them up via `images.fromCache(...)`) once [flameImagePrefix] is
/// set on the game's cache. Plain Flutter `Image.asset(...)` call sites
/// prepend `assets/` themselves (e.g. `'assets/${AssetConstants.iconCoin}'`).
class AssetConstants {
  AssetConstants._();

  /// Flame's `Images` cache defaults to prefix `'assets/images/'`; this
  /// project's pack is organized into multiple category folders instead,
  /// so `TapDotGame.onLoad` sets `images.prefix = flameImagePrefix` once,
  /// then every constant below is looked up relative to it.
  static const String flameImagePrefix = 'assets/';

  /// Full `Image.asset()` key for a path relative to `assets/` (e.g.
  /// `AssetConstants.asset(AssetConstants.iconCoin)`), so the `assets/`
  /// prefix lives in one place instead of being retyped at every call site.
  static String asset(String relativePath) => 'assets/$relativePath';

  static const String audioPath = 'assets/audio/';

  // --- branding ---
  static const String logo = 'branding/logo_tap_the_dot.png';

  // --- buttons ---
  static const String buttonPlay = 'buttons/button_play_green.png';
  static const String buttonHome = 'buttons/button_home_blue.png';
  static const String buttonRestart = 'buttons/button_restart_blue.png';
  static const String buttonShop = 'buttons/button_shop_yellow.png';
  static const String buttonBack = 'buttons/button_back_blue.png';
  static const String buttonPause = 'buttons/button_pause_blue.png';
  static const String buttonSettings = 'buttons/button_settings_blue.png';
  static const String toggleOnOff = 'buttons/toggle_on_off.png';

  // --- characters (in-run sprites) ---
  static const String dotClassic = 'characters/dot_classic.png';
  static const String dotCandy = 'characters/dot_candy.png';
  static const String dotFire = 'characters/dot_fire.png';
  static const String dotIce = 'characters/dot_ice.png';
  static const String dotNeon = 'characters/dot_neon.png';
  static const String dotRainbow = 'characters/dot_rainbow.png';
  static const String bomb = 'characters/bomb.png';

  // --- icons ---
  static const String iconCoin = 'icons/icon_coin.png';
  static const String iconTrophy = 'icons/icon_trophy.png';
  static const String iconStar = 'icons/icon_star.png';
  static const String iconGift = 'icons/icon_gift.png';
  static const String iconStopwatch = 'icons/icon_stopwatch.png';
  static const String iconComboFire = 'icons/icon_combo_fire.png';

  // --- panels ---
  static const String panelGameOver = 'panels/panel_game_over.png';
  static const String panelLevelResult = 'panels/panel_level_result.png';
  static const String panelProfileStats = 'panels/panel_profile_stats.png';
  static const String panelSettings = 'panels/panel_settings.png';
  static const String panelShopGrid = 'panels/panel_shop_grid.png';
  static const String cardShopItem = 'panels/card_shop_item.png';

  // --- hud ---
  static const String hudTopBar = 'hud/hud_gameplay_top_bar.png';
  static const String loadingBar = 'hud/loading_bar.png';
  static const String notificationBars = 'hud/notification_bars.png';

  // --- effects ---
  static const String softGlow = 'effects/soft_glow.png';

  // --- backgrounds (7 portrait page variants) ---
  static const String backgroundHome = 'backgrounds/background_page_01.png';
  static const String backgroundGame = 'backgrounds/background_page_02.png';
  static const String backgroundSettings =
      'backgrounds/background_page_03_twilight.png';
  static const String backgroundShop = 'backgrounds/background_page_04.png';
  static const String backgroundProfile = 'backgrounds/background_page_05.png';
  static const String backgroundRewards = 'backgrounds/background_page_07.png';

  // --- audio (imported so far) ---
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
