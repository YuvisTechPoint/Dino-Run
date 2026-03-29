import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'dart:math';
import '../models/game_theme.dart';

/// Simplified effects manager for basic visual effects
class EffectsManager {
  static final EffectsManager _instance = EffectsManager._internal();
  factory EffectsManager() => _instance;
  EffectsManager._internal();

  GameTheme? _currentTheme;

  /// Set the current theme for effects
  void setCurrentTheme(GameTheme theme) {
    _currentTheme = theme;
  }

  /// Create weather effects for the current theme
  List<Component> createWeatherEffect(Vector2 screenSize) {
    final effects = <Component>[];
    if (_currentTheme == null) return effects;

    switch (_currentTheme!.type) {
      case GameThemeType.winter:
        // Add snow effect
        for (int i = 0; i < 20; i++) {
          final snowflake = SnowflakeComponent(
            position: Vector2(
              Random().nextDouble() * screenSize.x,
              Random().nextDouble() * screenSize.y,
            ),
            fallSpeed: 50 + Random().nextDouble() * 50,
            swayAmount: 20 + Random().nextDouble() * 20,
          );
          effects.add(snowflake);
        }
        break;
      case GameThemeType.ocean:
        // Add bubble effect
        for (int i = 0; i < 10; i++) {
          final bubble = BubbleComponent(
            position: Vector2(
              Random().nextDouble() * screenSize.x,
              screenSize.y + Random().nextDouble() * 100,
            ),
            riseSpeed: 30 + Random().nextDouble() * 30,
            swayAmount: 15 + Random().nextDouble() * 15,
          );
          effects.add(bubble);
        }
        break;
      case GameThemeType.space:
        // Add star effect
        for (int i = 0; i < 15; i++) {
          final star = StarComponent(
            position: Vector2(
              Random().nextDouble() * screenSize.x,
              Random().nextDouble() * screenSize.y,
            ),
            twinkleSpeed: 2 + Random().nextDouble() * 3,
            brightness: 0.5 + Random().nextDouble() * 0.5,
          );
          effects.add(star);
        }
        break;
      default:
        // No weather effects for other themes
        break;
    }

    return effects;
  }

  /// Create special effects for the current theme
  List<Component> createSpecialEffects(Vector2 screenSize) {
    final effects = <Component>[];
    if (_currentTheme == null) return effects;

    switch (_currentTheme!.type) {
      case GameThemeType.candy:
        // Add sparkle effect
        for (int i = 0; i < 8; i++) {
          final sparkle = CandySparkleComponent(
            position: Vector2(
              Random().nextDouble() * screenSize.x,
              Random().nextDouble() * screenSize.y,
            ),
            sparkleSpeed: 3 + Random().nextDouble() * 2,
          );
          effects.add(sparkle);
        }
        break;
      case GameThemeType.forest:
        // Add firefly effect
        for (int i = 0; i < 6; i++) {
          final firefly = FireflyComponent(
            position: Vector2(
              Random().nextDouble() * screenSize.x,
              Random().nextDouble() * screenSize.y,
            ),
            glowIntensity: 0.5 + Random().nextDouble() * 0.5,
          );
          effects.add(firefly);
        }
        break;
      default:
        // No special effects for other themes
        break;
    }

    return effects;
  }

  /// Clear all active effects
  void clearAllEffects() {
    // Effects are managed by the game world, so this is just a placeholder
  }
}

// Simplified effect components
class SnowflakeComponent extends PositionComponent {
  final double fallSpeed;
  final double swayAmount;
  double _time = 0;

  SnowflakeComponent({
    required Vector2 position,
    required this.fallSpeed,
    required this.swayAmount,
  }) : super(position: position, size: Vector2(4, 4));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y += fallSpeed * dt;
    position.x += swayAmount * dt * 0.5;
  }
}

class BubbleComponent extends PositionComponent {
  final double riseSpeed;
  final double swayAmount;
  double _time = 0;

  BubbleComponent({
    required Vector2 position,
    required this.riseSpeed,
    required this.swayAmount,
  }) : super(position: position, size: Vector2(8, 8));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.3);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y -= riseSpeed * dt;
    position.x += swayAmount * dt * 0.3;
  }
}

class StarComponent extends PositionComponent {
  final double twinkleSpeed;
  final double brightness;
  double _time = 0;

  StarComponent({
    required Vector2 position,
    required this.twinkleSpeed,
    required this.brightness,
  }) : super(position: position, size: Vector2(4, 4));

  @override
  void render(Canvas canvas) {
    final opacity = (sin(_time * twinkleSpeed) + 1) / 2 * brightness;
    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

class CandySparkleComponent extends PositionComponent {
  final double sparkleSpeed;
  double _time = 0;

  CandySparkleComponent({
    required Vector2 position,
    required this.sparkleSpeed,
  }) : super(position: position, size: Vector2(3, 3));

  @override
  void render(Canvas canvas) {
    final opacity = (sin(_time * sparkleSpeed) + 1) / 2;
    final paint = Paint()..color = Colors.pink.withOpacity(opacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

class FireflyComponent extends PositionComponent {
  final double glowIntensity;
  double _time = 0;

  FireflyComponent({
    required Vector2 position,
    required this.glowIntensity,
  }) : super(position: position, size: Vector2(4, 4));

  @override
  void render(Canvas canvas) {
    final glow = (sin(_time * 2) + 1) / 2 * glowIntensity;
    final paint = Paint()..color = Colors.yellow.withOpacity(glow);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.x += sin(_time) * dt * 20;
    position.y += cos(_time) * dt * 15;
  }
}
