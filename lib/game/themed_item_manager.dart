import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '/game/themed_coin.dart';
import '/game/themed_power_up.dart';
import '/game/dino_run.dart';
import '/models/player_data.dart';
import '/models/game_theme.dart';

/// Manages spawning of themed collectibles and power-ups
class ThemedItemManager extends Component with HasGameReference<DinoRun> {
  // Timers for spawning items
  Timer _coinTimer = Timer(3, repeat: true);
  Timer _powerUpTimer = Timer(8, repeat: true);
  
  // Random generator
  final Random _random = Random();
  
  // Base spawn rates that adjust with difficulty
  double _baseCoinSpawnRate = 3.0;
  double _basePowerUpSpawnRate = 8.0;
  
  // Score threshold for difficulty increase
  int _lastDifficultyScore = 0;

  ThemedItemManager() {
    _coinTimer.onTick = _spawnThemedCoin;
    _powerUpTimer.onTick = _spawnThemedPowerUp;
  }

  @override
  void onMount() {
    _coinTimer.start();
    _powerUpTimer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _updateDifficulty();
    _coinTimer.update(dt);
    _powerUpTimer.update(dt);
    super.update(dt);
  }

  void _spawnThemedCoin() {
    final currentTheme = game.themeManager.currentTheme;
    final image = _getThemeCoinImage(currentTheme);
    
    final coin = ThemedCoin(image, game.playerData);
    
    // Set random position at top right of screen
    final randomY = _random.nextDouble() * (game.virtualSize.y - 100) + 50;
    coin.position = Vector2(game.virtualSize.x + 32, randomY);
    
    // Set size based on theme
    coin.size = _getThemeCoinSize(currentTheme);
    
    game.world.add(coin);
  }

  void _spawnThemedPowerUp() {
    final currentTheme = game.themeManager.currentTheme;
    final powerUpType = _getRandomPowerUpType();
    final image = _getThemePowerUpImage(currentTheme, powerUpType);
    
    final powerUp = ThemedPowerUp(image, powerUpType, game.playerData);
    
    // Set random position at top right of screen
    final randomY = _random.nextDouble() * (game.virtualSize.y - 100) + 50;
    powerUp.position = Vector2(game.virtualSize.x + 32, randomY);
    
    // Set size based on theme
    powerUp.size = _getThemePowerUpSize(currentTheme, powerUpType);
    
    game.world.add(powerUp);
  }

  Image _getThemeCoinImage(GameTheme theme) {
    // For now, use placeholder images - in real implementation, these would be actual theme assets
    switch (theme.type) {
      case GameThemeType.classic:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for coin
      case GameThemeType.desert:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for water drop
      case GameThemeType.forest:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for berry
      case GameThemeType.city:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for energy drink
    }
  }

  Image _getThemePowerUpImage(GameTheme theme, PowerUpType type) {
    // For now, use placeholder images - in real implementation, these would be actual theme assets
    switch (theme.type) {
      case GameThemeType.classic:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for star
      case GameThemeType.desert:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for canteen
      case GameThemeType.forest:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for mushroom
      case GameThemeType.city:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for helmet
    }
  }

  Vector2 _getThemeCoinSize(GameTheme theme) {
    switch (theme.type) {
      case GameThemeType.classic:
        return Vector2(16, 16);
      case GameThemeType.desert:
        return Vector2(20, 20); // Water drops are larger
      case GameThemeType.forest:
        return Vector2(18, 18); // Berries are medium
      case GameThemeType.city:
        return Vector2(22, 22); // Energy drinks are largest
    }
  }

  Vector2 _getThemePowerUpSize(GameTheme theme, PowerUpType type) {
    switch (theme.type) {
      case GameThemeType.classic:
        return Vector2(24, 24);
      case GameThemeType.desert:
        return Vector2(26, 26); // Desert items are slightly larger
      case GameThemeType.forest:
        return Vector2(25, 25); // Forest items are medium
      case GameThemeType.city:
        return Vector2(30, 30); // City items are largest
    }
  }

  PowerUpType _getRandomPowerUpType() {
    final types = PowerUpType.values;
    return types[_random.nextInt(types.length)];
  }

  // Update difficulty based on current score
  void _updateDifficulty() {
    final currentScore = game.playerData.currentScore;
    
    // Increase difficulty every 100 points
    if (currentScore >= _lastDifficultyScore + 100) {
      _lastDifficultyScore = (currentScore ~/ 100) * 100;
      _increaseDifficulty();
    }
  }
  
  // Increase difficulty by reducing spawn rates
  void _increaseDifficulty() {
    // Reduce coin spawn rate (make coins spawn more frequently)
    _baseCoinSpawnRate = (_baseCoinSpawnRate * 0.9).clamp(1.0, 3.0);
    
    // Reduce power-up spawn rate (make power-ups spawn more frequently)
    _basePowerUpSpawnRate = (_basePowerUpSpawnRate * 0.9).clamp(3.0, 8.0);
    
    // Update timers with new spawn rates
    _coinTimer.stop();
    _coinTimer = Timer(_baseCoinSpawnRate, repeat: true);
    _coinTimer.onTick = _spawnThemedCoin;
    _coinTimer.start();
    
    _powerUpTimer.stop();
    _powerUpTimer = Timer(_basePowerUpSpawnRate, repeat: true);
    _powerUpTimer.onTick = _spawnThemedPowerUp;
    _powerUpTimer.start();
  }

  void removeAllItems() {
    // Remove all themed coins
    final coins = game.world.children.whereType<ThemedCoin>();
    for (var coin in coins) {
      coin.removeFromParent();
    }
    
    // Remove all themed power-ups
    final powerUps = game.world.children.whereType<ThemedPowerUp>();
    for (var powerUp in powerUps) {
      powerUp.removeFromParent();
    }
  }
}
