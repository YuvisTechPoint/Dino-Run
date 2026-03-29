import 'dart:math';

import 'package:flame/components.dart';

import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';
import '/models/game_theme.dart';

/// Enhanced enemy manager that adapts to current theme
class ThemedEnemyManager extends Component with HasGameReference<DinoRun> {
  // A list to hold data for all the enemies.
  final List<EnemyData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn next enemy.
  Timer _timer = Timer(2, repeat: true);

  // Base spawn rate that will increase with difficulty
  double _baseSpawnRate = 2.0;
  
  // Score threshold for difficulty increase
  int _lastDifficultyScore = 0;

  ThemedEnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    
    // Apply difficulty multiplier to enemy speed
    final difficultyMultiplier = _getDifficultyMultiplier();
    final modifiedEnemyData = EnemyData(
      image: enemyData.image,
      nFrames: enemyData.nFrames,
      stepTime: enemyData.stepTime,
      textureSize: enemyData.textureSize,
      speedX: enemyData.speedX * difficultyMultiplier,
      canFly: enemyData.canFly,
    );
    
    final enemy = Enemy(modifiedEnemyData);

    // Help in setting all enemies on ground.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(game.virtualSize.x + 32, game.virtualSize.y - 24);

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    enemy.size = enemyData.textureSize;
    game.world.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      _loadThemeEnemies();
    }
    _timer.start();
    super.onMount();
  }

  /// Load enemies based on current theme
  void _loadThemeEnemies() {
    final currentTheme = game.themeManager.currentTheme;
    
    switch (currentTheme.type) {
      case GameThemeType.classic:
        _loadClassicEnemies();
        break;
      case GameThemeType.desert:
        _loadDesertEnemies();
        break;
      case GameThemeType.forest:
        _loadForestEnemies();
        break;
      case GameThemeType.city:
        _loadCityEnemies();
        break;
      case GameThemeType.ocean:
      case GameThemeType.space:
      case GameThemeType.candy:
      case GameThemeType.winter:
      case GameThemeType.jungle:
      case GameThemeType.volcano:
        // For new themes, fall back to classic enemies until specific assets are available
        _loadClassicEnemies();
        break;
    }
  }
  
  /// Update the theme (public method called from game)
  void updateTheme(GameTheme newTheme) {
    _data.clear();
    _loadThemeEnemies();
  }

  void _loadClassicEnemies() {
    // Use placeholder images for now - in real implementation, these would be actual theme assets
    _data.addAll([
      EnemyData(
        image: game.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
        speedX: 80,
        canFly: false,
      ),
      EnemyData(
        image: game.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 100,
        canFly: true,
      ),
      EnemyData(
        image: game.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
        speedX: 150,
        canFly: false,
      ),
    ]);
  }

  void _loadDesertEnemies() {
    // For now, use classic sprites as placeholders
    // In real implementation, these would be desert-themed sprites
    _data.addAll([
      EnemyData(
        image: game.images.fromCache('AngryPig/Walk (36x30).png'), // Placeholder for scorpion
        nFrames: 8,
        stepTime: 0.15,
        textureSize: Vector2(40, 25),
        speedX: 90,
        canFly: false,
      ),
      EnemyData(
        image: game.images.fromCache('Bat/Flying (46x30).png'), // Placeholder for vulture
        nFrames: 6,
        stepTime: 0.12,
        textureSize: Vector2(50, 35),
        speedX: 110,
        canFly: true,
      ),
      EnemyData(
        image: game.images.fromCache('Rino/Run (52x34).png'), // Placeholder for snake
        nFrames: 10,
        stepTime: 0.08,
        textureSize: Vector2(45, 20),
        speedX: 130,
        canFly: false,
      ),
    ]);
  }

  void _loadForestEnemies() {
    // Forest-themed enemies (placeholders for now)
    _data.addAll([
      EnemyData(
        image: game.images.fromCache('AngryPig/Walk (36x30).png'), // Placeholder for wolf
        nFrames: 12,
        stepTime: 0.1,
        textureSize: Vector2(45, 30),
        speedX: 95,
        canFly: false,
      ),
      EnemyData(
        image: game.images.fromCache('Bat/Flying (46x30).png'), // Placeholder for eagle
        nFrames: 8,
        stepTime: 0.11,
        textureSize: Vector2(48, 32),
        speedX: 105,
        canFly: true,
      ),
      EnemyData(
        image: game.images.fromCache('Rino/Run (52x34).png'), // Placeholder for bear
        nFrames: 8,
        stepTime: 0.13,
        textureSize: Vector2(55, 35),
        speedX: 70,
        canFly: false,
      ),
    ]);
  }

  void _loadCityEnemies() {
    // City-themed enemies (placeholders for now)
    _data.addAll([
      EnemyData(
        image: game.images.fromCache('AngryPig/Walk (36x30).png'), // Placeholder for robot
        nFrames: 10,
        stepTime: 0.09,
        textureSize: Vector2(40, 40),
        speedX: 85,
        canFly: false,
      ),
      EnemyData(
        image: game.images.fromCache('Bat/Flying (46x30).png'), // Placeholder for drone
        nFrames: 4,
        stepTime: 0.15,
        textureSize: Vector2(35, 25),
        speedX: 120,
        canFly: true,
      ),
      EnemyData(
        image: game.images.fromCache('Rino/Run (52x34).png'), // Placeholder for security bot
        nFrames: 8,
        stepTime: 0.1,
        textureSize: Vector2(50, 40),
        speedX: 100,
        canFly: false,
      ),
    ]);
  }

  @override
  void update(double dt) {
    _updateDifficulty();
    _timer.update(dt);
    super.update(dt);
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
  
  // Increase difficulty by reducing spawn rate and increasing enemy speed
  void _increaseDifficulty() {
    // Reduce spawn rate (make enemies spawn more frequently)
    _baseSpawnRate = (_baseSpawnRate * 0.9).clamp(0.5, 2.0);
    
    // Update timer with new spawn rate
    _timer.stop();
    _timer = Timer(_baseSpawnRate, repeat: true);
    _timer.onTick = spawnRandomEnemy;
    _timer.start();
  }
  
  // Get difficulty multiplier based on score
  double _getDifficultyMultiplier() {
    final scoreMultiplier = 1.0 + (game.playerData.currentScore / 500.0);
    return scoreMultiplier.clamp(1.0, 3.0); // Max 3x speed
  }

  void removeAllEnemies() {
    final enemies = game.world.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
  
  /// Reload enemies when theme changes
  void reloadForTheme() {
    _data.clear();
    _loadThemeEnemies();
  }
}
