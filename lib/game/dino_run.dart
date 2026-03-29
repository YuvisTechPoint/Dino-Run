import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '/game/dino.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/themed_enemy_manager.dart';
import '/game/themed_parallax.dart';
import '/game/themed_item_manager.dart';
import '/game/themed_ground.dart';
import '/models/player_data.dart';
import '/models/achievement.dart';
import '/models/game_theme.dart';
import '/managers/theme_manager.dart';
import '/managers/asset_preloader.dart';
import '/game/effects_manager.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';
import '/widgets/achievement_notification.dart';

// This is the main flame game class.
class DinoRun extends FlameGame with TapDetector, HasCollisionDetection {
  DinoRun({super.camera});

  // List of all the image assets.
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  // List of all the audio assets.
  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
    'coin.wav',
    'powerup.wav',
  ];

  late Dino _dino;
  late Settings settings;
  late PlayerData playerData;
  late ThemedEnemyManager _enemyManager;
  late ThemedItemManager _itemManager;
  late ThemedGround _themedGround;
  late AchievementManager _achievementManager;
  late ThemeManager _themeManager;
  late ThemedParallax _themedParallax;
  late EffectsManager _effectsManager;
  late AssetPreloader _assetPreloader;

  Vector2 get virtualSize => camera.viewport.virtualSize;
  
  // Make theme manager accessible to other components
  ThemeManager get themeManager => _themeManager;
  EffectsManager get effectsManager => _effectsManager;
  AssetPreloader get assetPreloader => _assetPreloader;

  // This method get called while flame is preparing this game.
  @override
  Future<void> onLoad() async {
    // Makes the game full screen and landscape only.
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    /// Read [PlayerData] and [Settings] from hive.
    playerData = await _readPlayerData();
    settings = await _readSettings();
    _achievementManager = AchievementManager();
    _themeManager = ThemeManager();
    _effectsManager = EffectsManager();
    _assetPreloader = AssetPreloader();

    /// Initilize [AudioManager].
    await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);
    
    // Preload all theme assets for instant access
    await _assetPreloader.preloadAllAssets(images);
    
    // Set current theme for effects manager
    _effectsManager.setCurrentTheme(_themeManager.currentTheme);

    // This makes the camera look at the center of the viewport.
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;

    /// Create a [ThemedParallax] and add it to game.
    _themedParallax = ThemedParallax();
    world.add(_themedParallax);
    
    /// Create a [ThemedGround] and add it to game.
    _themedGround = ThemedGround();
    world.add(_themedGround);
  }

  /// This method add the already created [Dino]
  /// and [EnemyManager] to this game.
  void startGamePlay() {
    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    _enemyManager = ThemedEnemyManager();
    _itemManager = ThemedItemManager();

    world.add(_dino);
    world.add(_enemyManager);
    world.add(_itemManager);
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
    _itemManager.removeAllItems();
    _itemManager.removeFromParent();
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();

    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    // Check for achievements
    _achievementManager.checkAchievements(playerData.currentScore);
    
    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
    super.update(dt);
  }

  /// Update the current theme and refresh all game elements
  Future<void> updateTheme(GameTheme newTheme) async {
    // Update theme manager
    await _themeManager.switchTheme(newTheme);
    
    // Update effects manager
    _effectsManager.setCurrentTheme(newTheme);
    
    // Update themed components
    _themedParallax.updateTheme(newTheme);
    _themedGround.updateTheme(newTheme);
    _enemyManager.updateTheme(newTheme);
    _itemManager.updateTheme(newTheme);
    
    // Add new weather and special effects
    final weatherEffects = _effectsManager.createWeatherEffect(virtualSize);
    final specialEffects = _effectsManager.createSpecialEffects(virtualSize);
    
    // Remove old effects and add new ones
    _effectsManager.clearAllEffects();
    for (final effect in [...weatherEffects, ...specialEffects]) {
      world.add(effect);
    }
    
    // Update background music if available
    if (newTheme.backgroundMusic != 'audio/default_theme.mp3') {
      AudioManager.instance.startBgm(newTheme.backgroundMusic);
    }
  }

  // This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make dino jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  /// This method reads [PlayerData] from the hive box.
  Future<PlayerData> _readPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>(
      'DinoRun.PlayerDataBox',
    );
    final playerData = playerDataBox.get('DinoRun.PlayerData');

    // If data is null, this is probably a fresh launch of the game.
    if (playerData == null) {
      // In such cases store default values in hive.
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }

    // Now it is safe to return the stored value.
    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  /// This method reads [Settings] from the hive box.
  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');

    // If data is null, this is probably a fresh launch of the game.
    if (settings == null) {
      // In such cases store default values in hive.
      await settingsBox.put('DinoRun.Settings', Settings(bgm: true, sfx: true));
    }

    // Now it is safe to return the stored value.
    return settingsBox.get('DinoRun.Settings')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
