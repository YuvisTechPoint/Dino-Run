import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
import 'dino.dart';
import 'enemy.dart';
import 'enemy_manager.dart';
import 'themed_enemy_manager.dart';
import 'item_manager.dart';
import 'themed_item_manager.dart';
import 'themed_parallax.dart';
import 'themed_ground.dart';
import 'themed_coin.dart';
import 'themed_power_up.dart';
import 'themed_background.dart';
import '../managers/theme_manager.dart';
import '../managers/asset_preloader.dart';
import '../managers/character_manager.dart';
import '../managers/effects_manager.dart';
import '../models/player_data.dart';
import '../models/player_profile.dart';
import '../models/character.dart';
import '../models/daily_challenge.dart';
import '../models/skill_tree.dart';
import '../models/game_theme.dart';
import '../widgets/enhanced_hud.dart';
import '../widgets/hud.dart';
import '../widgets/game_over_menu.dart';
import '../widgets/pause_menu.dart';
import '../widgets/theme_selection_menu.dart';
import '../widgets/theme_preview.dart';
import '../audio/audio_manager.dart';
import 'boss_battle.dart';

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
  late PlayerProfile _playerProfile;
  late CharacterManager _characterManager;
  late DailyChallengeManager _challengeManager;
  late SkillTreeManager _skillManager;
  late BossBattleManager _bossManager;
  late EnhancedHud _enhancedHud;

  Vector2 get virtualSize => camera.viewport.virtualSize;
  
  // Make managers accessible to other components
  ThemeManager get themeManager => _themeManager;
  EffectsManager get effectsManager => _effectsManager;
  AssetPreloader get assetPreloader => _assetPreloader;
  PlayerProfile get playerProfile => _playerProfile;
  CharacterManager get characterManager => _characterManager;
  DailyChallengeManager get challengeManager => _challengeManager;
  SkillTreeManager get skillManager => _skillManager;
  BossBattleManager get bossManager => _bossManager;

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
    _playerProfile = await _readPlayerProfile();
    _characterManager = CharacterManager();
    _challengeManager = DailyChallengeManager();
    _skillManager = SkillTreeManager();
    _bossManager = BossBattleManager();

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
    
    // Check for boss battle trigger
    checkBossBattleTrigger(playerData.currentScore);
    
    // Update daily streak
    _playerProfile.updateDailyStreak();
    
    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      // Update game statistics before game over
      updateGameStats(
        score: playerData.currentScore,
        distance: (playerData.currentScore * 10).floor(), // Estimate distance
        enemiesDefeated: _enemyManager.enemies.length, // Simplified
        powerUpsCollected: _itemManager.items.length, // Simplified
        tookDamage: playerData.lives < 5,
        timeElapsed: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Simplified
        maxCombo: playerData.comboCount,
      );
      
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

  /// This method reads [PlayerProfile] from the hive box.
  Future<PlayerProfile> _readPlayerProfile() async {
    final profileBox = await Hive.openBox<PlayerProfile>(
      'DinoRun.PlayerProfileBox',
    );
    final profile = profileBox.get('DinoRun.PlayerProfile');

    // If data is null, this is probably a fresh launch of the game.
    if (profile == null) {
      // In such cases store default values in hive.
      await profileBox.put('DinoRun.PlayerProfile', PlayerProfile());
    }

    // Now it is safe to return the stored value.
    return profileBox.get('DinoRun.PlayerProfile')!;
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

  /// Start boss battle
  void startBossBattle() {
    if (!_bossManager.isBossActive) {
      final currentTheme = _themeManager.currentTheme;
      _bossManager.startBossBattle(
        currentTheme.type,
        Vector2(virtualSize.x * 0.8, virtualSize.y * 0.5),
      );
    }
  }

  /// Update game statistics after run
  void updateGameStats({
    required int score,
    required int distance,
    required int enemiesDefeated,
    required int powerUpsCollected,
    required bool tookDamage,
    required int timeElapsed,
    int maxCombo = 0,
  }) {
    _playerProfile.updateGameStats(
      score: score,
      distance: distance,
      enemiesDefeated: enemiesDefeated,
      powerUpsCollected: powerUpsCollected,
      tookDamage: tookDamage,
      themeUsed: _themeManager.currentTheme.type.toString(),
    );

    // Check daily challenges
    _challengeManager.checkChallenges(
      score: score,
      distance: distance,
      coins: score ~/ 10, // Estimate coins from score
      enemies: enemiesDefeated,
      powerUps: powerUpsCollected,
      perfectRun: !tookDamage,
      timeElapsed: timeElapsed,
      themeUsed: _themeManager.currentTheme.type.toString(),
      characterUsed: _characterManager.selectedCharacter?.id ?? 'dino_classic',
      maxCombo: maxCombo,
    );

    // Add character experience
    _characterManager.addCharacterExperience(score ~/ 5);

    // Update player title based on level
    _playerProfile.updateTitle();
  }

  /// Get comprehensive game statistics
  Map<String, dynamic> getGameStatistics() {
    return {
      'playerProfile': {
        'name': _playerProfile.playerName,
        'level': _playerProfile.playerLevel,
        'experience': _playerProfile.experiencePoints,
        'totalCoins': _playerProfile.totalCoins,
        'totalGamesPlayed': _playerProfile.totalGamesPlayed,
        'totalPlayTime': _playerProfile.totalPlayTime,
        'longestRun': _playerProfile.longestRun,
        'totalDistance': _playerProfile.totalDistance,
        'totalEnemiesDefeated': _playerProfile.totalEnemiesDefeated,
        'totalPowerUpsCollected': _playerProfile.totalPowerUpsCollected,
        'perfectRuns': _playerProfile.perfectRuns,
        'currentStreak': _playerProfile.currentStreak,
        'title': _playerProfile.getCurrentTitle(),
      },
      'characterStats': {
        'selectedCharacter': _characterManager.selectedCharacter?.name ?? 'None',
        'unlockedCharacters': _characterManager.getUnlockedCharacters().length,
        'totalCharacters': _characterManager.characters.length,
      },
      'achievementStats': {
        'totalAchievements': _achievementManager.totalCount,
        'unlockedAchievements': _achievementManager.unlockedCount,
      },
      'challengeStats': {
        'completedToday': _challengeManager.completedCount,
        'totalChallenges': _challengeManager.challenges.length,
        'coinsAvailable': _challengeManager.getTotalCoinsAvailable(),
        'experienceAvailable': _challengeManager.getTotalExperienceAvailable(),
      },
      'skillStats': {
        'totalSkillLevel': _skillManager.getTotalSkillLevel(),
        'unlockedSkills': _skillManager.getUnlockedSkills().length,
        'skillPoints': _skillManager.skillPoints,
      },
      'bossStats': {
        'bossesDefeated': _bossManager.bossesDefeated,
        'defeatedBossTypes': _bossManager.defeatedBossTypes.length,
        'isBossActive': _bossManager.isBossActive,
      },
    };
  }

  /// Trigger boss battle at certain score thresholds
  void checkBossBattleTrigger(int score) {
    // Trigger boss battle every 5000 points
    if (score > 0 && score % 5000 == 0 && !_bossManager.isBossActive) {
      startBossBattle();
    }
  }
}
