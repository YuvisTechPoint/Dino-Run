import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../models/player_profile.dart';
import '../models/character.dart';
import '../models/daily_challenge.dart';
import '../models/skill_tree.dart';

/// Enhanced HUD with comprehensive game information
class EnhancedHud extends PositionComponent {
  late PlayerProfile _playerProfile;
  late Character _currentCharacter;
  late DailyChallengeManager _challengeManager;
  late SkillTreeManager _skillManager;
  
  // UI Components
  late TextComponent _scoreText;
  late TextComponent _coinsText;
  late TextComponent _levelText;
  late TextComponent _comboText;
  late TextComponent _healthText;
  late TextComponent _powerUpText;
  late TextComponent _challengeText;
  
  // Progress bars
  late ProgressBar _healthBar;
  late ProgressBar _experienceBar;
  late ProgressBar _comboBar;
  
  // Status indicators
  List<StatusIndicator> _statusIndicators = [];
  
  @override
  Future<void> onLoad() async {
    // Initialize text components
    _scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _coinsText = TextComponent(
      text: 'Coins: 0',
      position: Vector2(10, 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _levelText = TextComponent(
      text: 'Level: 1',
      position: Vector2(10, 70),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _comboText = TextComponent(
      text: 'Combo: x1',
      position: Vector2(10, 100),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _healthText = TextComponent(
      text: 'Health: 5/5',
      position: Vector2(10, 130),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _powerUpText = TextComponent(
      text: '',
      position: Vector2(10, 160),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    _challengeText = TextComponent(
      text: '',
      position: Vector2(10, 190),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    // Initialize progress bars
    _healthBar = ProgressBar(
      position: Vector2(150, 130),
      size: Vector2(100, 16),
      maxValue: 5,
      currentValue: 5,
      color: Colors.red,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
    
    _experienceBar = ProgressBar(
      position: Vector2(80, 70),
      size: Vector2(70, 8),
      maxValue: 100,
      currentValue: 0,
      color: Colors.green,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
    
    _comboBar = ProgressBar(
      position: Vector2(80, 100),
      size: Vector2(70, 8),
      maxValue: 10,
      currentValue: 0,
      color: Colors.orange,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
    
    // Add all components to HUD
    add(_scoreText);
    add(_coinsText);
    add(_levelText);
    add(_comboText);
    add(_healthText);
    add(_powerUpText);
    add(_challengeText);
    add(_healthBar);
    add(_experienceBar);
    add(_comboBar);
    
    // Initialize status indicators
    _initializeStatusIndicators();
  }

  void _initializeStatusIndicators() {
    // Add status indicators for various effects
    _statusIndicators = [
      StatusIndicator(
        icon: Icons.flash_on,
        color: Colors.blue,
        position: Vector2(300, 10),
        name: 'speed_boost',
      ),
      StatusIndicator(
        icon: Icons.shield,
        color: Colors.green,
        position: Vector2(330, 10),
        name: 'shield',
      ),
      StatusIndicator(
        icon: Icons.local_fire_department,
        color: Colors.orange,
        position: Vector2(360, 10),
        name: 'combo_master',
      ),
      StatusIndicator(
        icon: Icons.star,
        color: Colors.purple,
        position: Vector2(390, 10),
        name: 'invincibility',
      ),
    ];
    
    for (final indicator in _statusIndicators) {
      add(indicator);
    }
  }

  /// Update score display
  void updateScore(int score) {
    _scoreText.text = 'Score: $score';
  }

  /// Update coins display
  void updateCoins(int coins) {
    _coinsText.text = 'Coins: $coins';
  }

  /// Update level and experience
  void updateLevel(int level, int experience, int experienceToNext) {
    _levelText.text = 'Level: $level';
    _experienceBar.maxValue = experienceToNext.toDouble();
    _experienceBar.currentValue = experience.toDouble();
  }

  /// Update combo display
  void updateCombo(int combo, int maxCombo) {
    _comboText.text = 'Combo: x$combo';
    _comboBar.currentValue = combo.toDouble();
    _comboBar.maxValue = maxCombo.toDouble();
  }

  /// Update health display
  void updateHealth(int currentHealth, int maxHealth) {
    _healthText.text = 'Health: $currentHealth/$maxHealth';
    _healthBar.maxValue = maxHealth.toDouble();
    _healthBar.currentValue = currentHealth.toDouble();
  }

  /// Update power-up display
  void updatePowerUp(String powerUpName, Duration remainingTime) {
    if (remainingTime.inSeconds > 0) {
      _powerUpText.text = '$powerUpName: ${remainingTime.inSeconds}s';
    } else {
      _powerUpText.text = '';
    }
  }

  /// Update challenge progress
  void updateChallengeProgress(String challengeText) {
    _challengeText.text = challengeText;
  }

  /// Show status indicator
  void showStatusIndicator(String statusName) {
    final indicator = _statusIndicators
        .where((ind) => ind.name == statusName)
        .firstOrNull;
    
    if (indicator != null) {
      indicator.show();
    }
  }

  /// Hide status indicator
  void hideStatusIndicator(String statusName) {
    final indicator = _statusIndicators
        .where((ind) => ind.name == statusName)
        .firstOrNull;
    
    if (indicator != null) {
      indicator.hide();
    }
  }

  /// Show damage indicator
  void showDamageIndicator(int damage, Vector2 position) {
    final damageText = DamageIndicator(
      damage: damage,
      position: position,
    );
    add(damageText);
  }

  /// Show level up effect
  void showLevelUpEffect() {
    final levelUpEffect = LevelUpEffect(
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(levelUpEffect);
  }

  /// Show achievement notification
  void showAchievementNotification(String achievementName) {
    final notification = AchievementNotification(
      achievementName: achievementName,
      position: Vector2(size.x / 2, 100),
    );
    add(notification);
  }
}

/// Progress bar component
class ProgressBar extends PositionComponent {
  final double maxValue;
  double currentValue;
  final Color color;
  final Color backgroundColor;
  
  ProgressBar({
    required Vector2 position,
    required Vector2 size,
    required this.maxValue,
    required this.currentValue,
    required this.color,
    required this.backgroundColor,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    // Draw background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      bgPaint,
    );
    
    // Draw fill
    final fillPercentage = (currentValue / maxValue).clamp(0.0, 1.0);
    final fillPaint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x * fillPercentage, size.y),
      fillPaint,
    );
    
    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      borderPaint,
    );
  }

  void updateValue(double newValue) {
    currentValue = newValue.clamp(0.0, maxValue);
  }
}

/// Status indicator for active effects
class StatusIndicator extends PositionComponent {
  final IconData icon;
  final Color color;
  final String name;
  bool _isVisible = false;
  double _opacity = 0.0;

  StatusIndicator({
    required this.icon,
    required this.color,
    required Vector2 position,
    required this.name,
  }) : super(position: position, size: const Vector2(24, 24));

  @override
  void render(Canvas canvas) {
    if (!_isVisible) return;
    
    final paint = Paint()
      ..color = color.withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    
    // Draw icon background
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
    
    // Draw icon (simplified - would use proper icon rendering)
    final iconPaint = Paint()
      ..color = Colors.white.withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 3,
      iconPaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isVisible && _opacity < 1.0) {
      _opacity = (_opacity + dt * 3).clamp(0.0, 1.0);
    } else if (!_isVisible && _opacity > 0.0) {
      _opacity = (_opacity - dt * 3).clamp(0.0, 1.0);
    }
  }

  void show() {
    _isVisible = true;
  }

  void hide() {
    _isVisible = false;
  }
}

/// Damage indicator
class DamageIndicator extends PositionComponent {
  final int damage;
  double _lifetime = 2.0;
  double _opacity = 1.0;
  Vector2 _velocity = Vector2(0, -50);

  DamageIndicator({
    required this.damage,
    required Vector2 position,
  }) : super(position: position, size: const Vector2(50, 20));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = damage > 0 ? Colors.red : Colors.green
      ..style = PaintingStyle.fill;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: damage > 0 ? '-$damage' : '+${-damage}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    _lifetime -= dt;
    _opacity = (_lifetime / 2.0).clamp(0.0, 1.0);
    
    position += _velocity * dt;
    _velocity.y += dt * 20; // Gravity effect
    
    if (_lifetime <= 0) {
      removeFromParent();
    }
  }
}

/// Level up effect
class LevelUpEffect extends PositionComponent {
  double _lifetime = 3.0;
  double _scale = 0.0;
  double _opacity = 1.0;

  LevelUpEffect({required Vector2 position}) 
    : super(position: position, size: const Vector2(200, 100));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'LEVEL UP!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(_scale);
    canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    _lifetime -= dt;
    
    if (_lifetime > 2.0) {
      _scale = (3.0 - _lifetime) * 2;
    } else {
      _opacity = (_lifetime / 2.0).clamp(0.0, 1.0);
    }
    
    if (_lifetime <= 0) {
      removeFromParent();
    }
  }
}

/// Achievement notification
class AchievementNotification extends PositionComponent {
  final String achievementName;
  double _lifetime = 4.0;
  double _opacity = 0.0;
  double _slideOffset = 100.0;

  AchievementNotification({
    required this.achievementName,
    required Vector2 position,
  }) : super(position: position, size: const Vector2(300, 80));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.purple.withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    
    // Draw background
    final bgPaint = Paint()
      ..color = Colors.black.withOpacity(_opacity * 0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(10),
      ),
      bgPaint,
    );
    
    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Achievement Unlocked!\n',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: achievementName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    _lifetime -= dt;
    
    if (_lifetime > 3.0) {
      _opacity = (4.0 - _lifetime);
      _slideOffset = (4.0 - _lifetime) * 100;
    } else if (_lifetime < 1.0) {
      _opacity = _lifetime;
      _slideOffset = (1.0 - _lifetime) * 100;
    } else {
      _opacity = 1.0;
      _slideOffset = 0.0;
    }
    
    position.y = position.y - _slideOffset * dt;
    
    if (_lifetime <= 0) {
      removeFromParent();
    }
  }
}
