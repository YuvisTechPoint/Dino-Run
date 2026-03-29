import 'dart:math';

import 'package:flame/components.dart';

import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameReference<DinoRun> {
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

  EnemyManager() {
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
      // As soon as this component is mounted, initilize all the data.
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
    _timer.start();
    super.onMount();
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
}
