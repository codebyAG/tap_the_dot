# Tap The Dot — Project Context

_Last updated: 2026-09-19. This file is a snapshot for orientation, not a source of truth — verify against code before relying on specifics._

## What this is
A Flutter + Flame casual reflex/tapping mobile game. Player taps dots as they spawn within a 30-second run, building combo multipliers, triggering Fever Mode, buying/equipping skins, and earning coins. Android is the primary target platform.

## Stack
- Flutter (Dart SDK ^3.10.0), Material 3
- `flame` — real-time game engine/canvas layer
- `provider` — app-level state management
- `shared_preferences` — local persistence
- `audioplayers` — sound effects

## Folder structure (flat)
```
lib/
  main.dart            entry point
  app.dart             MaterialApp + MultiProvider root
  dependencies.dart     composition root (manual DI, builds providers)
  routes.dart           named route table (splash/home/game/shop/settings/profile/rewards)
  constants/            app_constants, asset_constants (asset paths, grouped by pack folder), game_constants (tunables)
  theme/                app_colors, app_text_styles, app_theme (rounded cartoon style)
  models/               domain entities: target (HitZone/TargetScoring), combo (ComboRules),
                         game_result, player_progress(+model), game_config, skin_config (SkinCatalog)
  services/              GameController (ChangeNotifier, app-level gameplay state),
                         AudioService, HapticService, StorageService,
                         GameRepository(+impl), GameLocalDataSource,
                         usecases: get_player_progress, save_score, save_player_progress
  game_engine/           Flame layer only: TapDotGame, components/, effects/, systems/
                         (difficulty ramp, spawn positions/golden-dot rolls)
  screens/               one file per route/page
  widgets/               reusable Flutter widgets shared across screens
```
Deliberately flat, not feature-based clean architecture — confirmed via explicit user choice.
All internal imports use absolute `package:tap_the_dot/...` paths (not relative), to avoid
deep `../../../` chains.

## Assets (`assets/`)
Two generations exist conceptually but only one is live — the original flat `assets/images/`
set was fully retired and removed; everything now comes from a categorized asset pack:
- `branding/` — logo_tap_the_dot.png
- `buttons/` — button_play_green, button_home_blue, button_restart_blue, button_shop_yellow
  (2172x724 pills: circular icon badge in the left square third, blank area for a label),
  button_back_blue, button_pause_blue, button_settings_blue (1254x1254 standalone circular
  badges), toggle_on_off.png (2172x724 sprite sheet — left half "ON" green frame, right half
  "OFF" grey frame, each exactly 50% width)
- `characters/` — dot_classic/candy/fire/ice/neon/rainbow.png (1254x1254, the purchasable
  skins) + bomb.png (imported, not yet used in gameplay)
- `icons/` — icon_coin, icon_trophy, icon_star, icon_gift, icon_stopwatch, icon_combo_fire
  (all 1254x1254)
- `panels/` — panel_game_over, panel_shop_grid, panel_profile_stats, panel_settings,
  panel_level_result (1086x1448 portrait cards), card_shop_item.png (1024x1536)
- `hud/` — hud_gameplay_top_bar, loading_bar (2172x724), notification_bars (1536x1024)
- `effects/` — soft_glow.png (used behind Splash/Profile avatars); folder reserved for more
- `backgrounds/` — 7 portrait page variants (941x1672); assigned per-screen via
  `AssetConstants.backgroundHome/backgroundGame/backgroundShop/backgroundSettings/
  backgroundProfile/backgroundRewards` for visual variety
- `audio/` — tap_sound.mp3, success_sound.mp3, coin_collect.mp3, bomb_explode.mp3 (4 more sfx
  referenced by name in `AssetConstants` aren't imported yet; `AudioService.play()` no-ops
  silently for those, by design)
- `pubspec.yaml` declares each pack folder individually (not a single `images/` catch-all).

**Known asset-usage limitation (deliberate):** `panel_settings.png` and the icon-row portion
of `panel_profile_stats.png` have UI mockup content baked directly into the pixels (static
"ON" toggles, fixed icon+text row layout) that can't be dynamically controlled or reliably
overlaid without an actual device/visual test pass. Settings and the lower part of Profile
use plain `CartoonPanel` containers instead, with individually-safe pieces of the pack
(the `toggle_on_off` sprite, icon assets) pulled in rather than the whole mockup image. The
generously-blank templates (`card_shop_item`, `panel_game_over`, the avatar-circle top band
of `panel_profile_stats`) are used directly as backdrops.

**Asset path convention:** `AssetConstants` constants are relative to `assets/` (no prefix),
matching Flame's `Images` cache convention. `AssetConstants.asset(path)` prepends `assets/`
for plain Flutter `Image.asset()` calls. `TapDotGame.onLoad` sets
`images.prefix = AssetConstants.flameImagePrefix` once so Flame lookups resolve the same way.

## Gameplay systems (fully implemented)
- **GameController** (`services/game_controller.dart`): owns the 30s countdown, score,
  combo, Fever Mode, coins, pause state, and skin/settings persistence. `TapDotGame` only
  reports outcomes to it via `registerHit` / `registerWrongTap` / `registerTimeout`.
- **Combo**: 5 tiers (x1–x5) by consecutive-hit thresholds (`ComboRules`). Wrong tap steps
  combo down by 1; a timed-out target resets combo to 0.
- **Fever Mode**: triggers at 10-combo, lasts 5s, doubles score.
- **Difficulty ramp** (`DifficultySystem`): first 4s pinned to easiest; ramps target size
  down / spawn rate up over 25s total.
- **Spawn** (`SpawnSystem`): safe-margin random positions, min separation from last spawn,
  5% chance of a bonus "Golden Dot" (+10 score, +5 coins).
- **Hit zones**: perfect/good/normal/miss by tap distance from target center. Perfect/Golden
  hits get an extra sparkle layer + `ExpandingRingEffect` (game_engine/effects) for bigger
  visual payoff.
- **Pause**: `GameController.pauseGame()/resumeGame()` freeze/restart the countdown Timer;
  `GamePage` separately calls `TapDotGame.pauseEngine()/resumeEngine()` (Flame's own engine
  pause) so targets stop animating/spawning too. `PauseOverlay` shows Resume/Home.
- **Skins**: `SkinCatalog` (models/skin_config.dart) is the single source of truth for
  id/name/sprite/price — Classic is free/default, the other 5 cost coins.
  `GameController.purchaseSkin()` deducts coins + unlocks + equips + persists in one step;
  `selectSkin()` re-equips an already-owned skin. `TapDotGame.onLoad` reads
  `controller.selectedSkinId` and loads that sprite (no longer hardcoded to dot_classic).
- **Settings**: `GameController.updateSettings()` applies sound/music/haptics to
  `AudioService`/`HapticService` immediately and persists via `SavePlayerProgress` — survives
  app restart.
- **Persistence**: `PlayerProgress` (bestScore, coins, unlockedSkinIds, selectedSkinId,
  sound/music/haptics flags) round-trips through `GameLocalDataSource` as JSON via
  `shared_preferences`. All fields are now actually read/written (previously only
  bestScore/coins were wired).

## Screens / navigation
All 8 screens exist: Splash, Home, Game, Shop, Settings, Profile, Rewards, Game Over.
- Game Over is an **overlay** (`GameOverOverlay`) shown on top of the Flame `GameWidget`
  inside `GamePage`, not a separate pushed route — avoids tearing down the Flame game to
  show results. Built on `panel_game_over.png`; includes a real-data-derived 3-star rating
  (hits>0 / perfectHits>=3 / isNewBest — no fabricated rating system).
- Shop/Settings/Profile/Rewards are named routes off Home's quick-nav row.
- Reusable widgets: `GameButton` (asset-backed pill CTA), `CartoonIconButton` (square badge
  or cropped-from-pill icon button), `CartoonToggle`, `CartoonPanel`, `StatBadge`,
  `ScreenTopBar`, `ShopSkinCard`, `RewardCard`, `PauseOverlay`.

## Conventions / preferences observed this session
- User wants a flat `lib/` layout (screens/widgets/models/services/theme), not feature-based
  clean architecture.
- Prefers existing working logic preserved during refactors ("move, don't rebuild").
- **Do not run `flutter analyze`/`run`/`build`/`devices` without explicit permission** —
  strong, repeated correction; saved to persistent memory. Permission was granted for one
  session's polish pass (analyze/format/test explicitly), not a standing yes.
- Wants only the new asset pack used — old `assets/images/` set was fully removed, not just
  superseded in code.
- Wants `flutter analyze`/tests run and all errors fixed before considering a task done
  (when permitted to run them).
