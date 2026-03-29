import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image;

import 'dino.dart';
import 'dino_run.dart';
import 'audio_manager.dart';
import '../models/player_data.dart';
import '../models/wallet.dart';

/// This represents a collectible coin in the game with wallet integration
class Coin extends SpriteAnimationComponent with HasGameReference<DinoRun>, CollisionCallbacks {
  static final _animationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2.all(16),
  );

  final PlayerData playerData;
  final Wallet wallet;
  final CoinType coinType;
  
  // Magnet attraction
  bool _isMagnetized = false;
  Vector2? _magnetTarget;
  static const double _magnetSpeed = 400.0;

  Coin(Image image, this.playerData, this.wallet, {this.coinType = CoinType.bronze}) 
      : super.fromFrameData(image, _animationData);

  @override
  void onMount() {
    add(
      RectangleHitbox.relative(
        Vector2(0.8, 0.8),
        parentSize: size,
        position: Vector2(size.x * 0.1, size.y * 0.1) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move left with game speed
    position.x -= 100 * dt;
    
    // Magnet attraction
    if (_isMagnetized && _magnetTarget != null) {
      final direction = (_magnetTarget! - position);
      final distance = direction.length;
      
      if (distance > 5) {
        final normalizedDir = direction.normalized();
        position += normalizedDir * _magnetSpeed * dt;
      }
    }
    
    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Dino) {
      _collect();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _collect() {
    // Add coins to wallet based on coin type
    wallet.addCoinsByType(coinType, 1);
    
    // Add small score bonus
    playerData.currentScore += coinType.value;
    
    // Increment combo
    playerData.incrementCombo();
    
    // Play collection sound
    AudioManager.instance.playSfx('coin.wav');
    
    // Remove coin from game
    removeFromParent();
  }
  
  /// Activate magnet attraction toward target position
  void activateMagnet(Vector2 target) {
    _isMagnetized = true;
    _magnetTarget = target;
  }
  
  /// Get color overlay based on coin type
  Color get typeColor {
    switch (coinType) {
      case CoinType.bronze:
        return const Color(0xFFCD7F32);
      case CoinType.silver:
        return const Color(0xFFC0C0C0);
      case CoinType.gold:
        return const Color(0xFFFFD700);
      case CoinType.diamond:
        return const Color(0xFFB9F2FF);
    }
  }
}

/// Manager for spawning coins during gameplay
class CoinManager extends Component with HasGameReference<DinoRun> {
  final Wallet wallet;
  final PlayerData playerData;
  
  // Spawn timers
  double _spawnTimer = 0.0;
  double _spawnInterval = 2.0;
  
  // Magnet power-up
  bool _magnetActive = false;
  double _magnetDuration = 0.0;
  
  CoinManager(this.wallet, this.playerData);
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update spawn timer
    _spawnTimer += dt;
    
    if (_spawnTimer >= _spawnInterval) {
      _spawnCoin();
      _spawnTimer = 0.0;
      
      // Decrease spawn interval as score increases (more coins at higher scores)
      final score = playerData.currentScore;
      _spawnInterval = score > 1000 ? 1.5 : (score > 500 ? 1.8 : 2.0);
    }
    
    // Update magnet duration
    if (_magnetActive) {
      _magnetDuration -= dt;
      if (_magnetDuration <= 0) {
        _magnetActive = false;
      }
    }
  }
  
  void _spawnCoin() {
    // Determine coin type based on probability
    final coinType = _getRandomCoinType();
    
    // Calculate spawn position (random height in jump range)
    final groundY = game.virtualSize.y - 22;
    final jumpHeight = 150.0;
    final randomHeight = (jumpHeight * 0.3) + (DateTime.now().millisecond % 100) / 100 * jumpHeight * 0.7;
    
    final spawnPosition = Vector2(
      game.virtualSize.x + 50,
      groundY - randomHeight,
    );
    
    // Create and add coin
    final coinImage = game.images.fromCache('collectibles/coin.png');
    final coin = Coin(coinImage, playerData, wallet, coinType: coinType)
      ..position = spawnPosition;
    
    // Activate magnet if active
    if (_magnetActive) {
      final playerPos = Vector2(50, game.virtualSize.y - 100);
      coin.activateMagnet(playerPos);
    }
    
    game.world.add(coin);
  }
  
  CoinType _getRandomCoinType() {
    final random = DateTime.now().millisecond / 1000;
    
    if (random < 0.03) return CoinType.diamond;      // 3%
    if (random < 0.15) return CoinType.gold;         // 12%
    if (random < 0.40) return CoinType.silver;       // 25%
    return CoinType.bronze;                          // 60%
  }
  
  /// Activate coin magnet power-up
  void activateMagnet(double duration) {
    _magnetActive = true;
    _magnetDuration = duration;
    
    // Activate magnet on all existing coins
    final coins = game.world.children.whereType<Coin>();
    for (final coin in coins) {
      final playerPos = Vector2(50, game.virtualSize.y - 100);
      coin.activateMagnet(playerPos);
    }
  }
  
  void removeAllCoins() {
    final coins = game.world.children.whereType<Coin>();
    for (final coin in coins.toList()) {
      coin.removeFromParent();
    }
  }
}

