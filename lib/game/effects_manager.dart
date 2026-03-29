import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../models/game_theme.dart';

/// Manages visual effects for different themes
class EffectsManager {
  static final EffectsManager _instance = EffectsManager._internal();
  factory EffectsManager() => _instance;
  EffectsManager._internal();

  final Map<String, List<Component>> _activeEffects = {};
  GameTheme? _currentTheme;

  /// Set current theme for effects
  void setCurrentTheme(GameTheme theme) {
    _currentTheme = theme;
  }

  /// Create weather effect based on theme
  List<Component> createWeatherEffect(Vector2 screenSize) {
    if (_currentTheme == null) return [];

    final effects = <Component>[];
    
    switch (_currentTheme!.weatherEffect) {
      case 'snow':
        effects.addAll(_createSnowEffect(screenSize));
        break;
      case 'rain':
        effects.addAll(_createRainEffect(screenSize));
        break;
      case 'sandstorm':
        effects.addAll(_createSandstormEffect(screenSize));
        break;
      case 'ash_storm':
        effects.addAll(_createAshStormEffect(screenSize));
        break;
      case 'candy_rain':
        effects.addAll(_createCandyRainEffect(screenSize));
        break;
      case 'meteor_shower':
        effects.addAll(_createMeteorShowerEffect(screenSize));
        break;
      case 'underwater_current':
        effects.addAll(_createUnderwaterCurrentEffect(screenSize));
        break;
      case 'humidity':
        effects.addAll(_createHumidityEffect(screenSize));
        break;
      case 'gentle_breeze':
        effects.addAll(_createGentleBreezeEffect(screenSize));
        break;
    }
    
    return effects;
  }

  /// Create special effects for theme
  List<Component> createSpecialEffects(Vector2 screenSize) {
    if (_currentTheme == null) return [];

    final effects = <Component>[];
    
    for (final specialEffect in _currentTheme!.specialEffects) {
      switch (specialEffect) {
        case 'retro_filter':
          effects.add(_createRetroFilterEffect(screenSize));
          break;
        case 'pixel_dust':
          effects.addAll(_createPixelDustEffect(screenSize));
          break;
        case 'heat_shimmer':
          effects.add(_createHeatShimmerEffect(screenSize));
          break;
        case 'mirage':
          effects.addAll(_createMirageEffect(screenSize));
          break;
        case 'fireflies':
          effects.addAll(_createFirefliesEffect(screenSize));
          break;
        case 'falling_leaves':
          effects.addAll(_createFallingLeavesEffect(screenSize));
          break;
        case 'neon_glow':
          effects.add(_createNeonGlowEffect(screenSize));
          break;
        case 'traffic_lights':
          effects.addAll(_createTrafficLightsEffect(screenSize));
          break;
        case 'bubble_animation':
          effects.addAll(_createBubblesEffect(screenSize));
          break;
        case 'underwater_glow':
          effects.add(_createUnderwaterGlowEffect(screenSize));
          break;
        case 'starfield':
          effects.addAll(_createStarfieldEffect(screenSize));
          break;
        case 'zero_gravity':
          effects.add(_createZeroGravityEffect());
          break;
        case 'rainbow_trail':
          effects.add(_createRainbowTrailEffect());
          break;
        case 'candy_sparkle':
          effects.addAll(_createCandySparkleEffect(screenSize));
          break;
        case 'aurora_lights':
          effects.addAll(_createAuroraLightsEffect(screenSize));
          break;
        case 'ice_reflection':
          effects.add(_createIceReflectionEffect(screenSize));
          break;
        case 'vine_swing':
          effects.addAll(_createVineSwingEffect(screenSize));
          break;
        case 'ancient_glow':
          effects.add(_createAncientGlowEffect(screenSize));
          break;
        case 'lava_glow':
          effects.add(_createLavaGlowEffect(screenSize));
          break;
        case 'ash_fall':
          effects.addAll(_createAshFallEffect(screenSize));
          break;
      }
    }
    
    return effects;
  }

  // Weather Effects Implementation
  List<Component> _createSnowEffect(Vector2 screenSize) {
    final snowflakes = <Component>[];
    for (int i = 0; i < 50; i++) {
      final snowflake = SnowflakeComponent(
        position: Vector2(
          (i * 20) % screenSize.x,
          -10 - (i * 15),
        ),
        size: Vector2.all(3 + (i % 3)),
        fallSpeed: 50 + (i % 30),
        swayAmount: 20 + (i % 10),
      );
      snowflakes.add(snowflake);
    }
    return snowflakes;
  }

  List<Component> _createRainEffect(Vector2 screenSize) {
    final raindrops = <Component>[];
    for (int i = 0; i < 100; i++) {
      final raindrop = RaindropComponent(
        position: Vector2(
          (i * 10) % screenSize.x,
          -20 - (i * 8),
        ),
        size: Vector2(1, 8 + (i % 4)),
        fallSpeed: 200 + (i % 50),
      );
      raindrops.add(raindrop);
    }
    return raindrops;
  }

  List<Component> _createSandstormEffect(Vector2 screenSize) {
    final sandParticles = <Component>[];
    for (int i = 0; i < 80; i++) {
      final sand = SandParticleComponent(
        position: Vector2(
          (i * 15) % screenSize.x,
          (i * 10) % screenSize.y,
        ),
        size: Vector2.all(2 + (i % 2)),
        moveSpeed: 30 + (i % 20),
        direction: Vector2(1 + (i % 3) * 0.5, (i % 5 - 2) * 0.2),
      );
      sandParticles.add(sand);
    }
    return sandParticles;
  }

  List<Component> _createAshStormEffect(Vector2 screenSize) {
    final ashParticles = <Component>[];
    for (int i = 0; i < 60; i++) {
      final ash = AshParticleComponent(
        position: Vector2(
          (i * 20) % screenSize.x,
          -10 - (i * 12),
        ),
        size: Vector2.all(1 + (i % 2)),
        fallSpeed: 20 + (i % 15),
        swayAmount: 15 + (i % 8),
      );
      ashParticles.add(ash);
    }
    return ashParticles;
  }

  List<Component> _createCandyRainEffect(Vector2 screenSize) {
    final candies = <Component>[];
    for (int i = 0; i < 30; i++) {
      final candy = CandyRainComponent(
        position: Vector2(
          (i * 25) % screenSize.x,
          -15 - (i * 20),
        ),
        size: Vector2.all(4 + (i % 3)),
        fallSpeed: 40 + (i % 25),
        rotationSpeed: 2 + (i % 3),
        candyType: i % 4,
      );
      candies.add(candy);
    }
    return candies;
  }

  List<Component> _createMeteorShowerEffect(Vector2 screenSize) {
    final meteors = <Component>[];
    for (int i = 0; i < 10; i++) {
      final meteor = MeteorComponent(
        position: Vector2(
          (i * 100) % screenSize.x,
          -50 - (i * 80),
        ),
        size: Vector2(3, 6 + (i % 4)),
        fallSpeed: 150 + (i % 100),
        trailLength: 20 + (i % 10),
      );
      meteors.add(meteor);
    }
    return meteors;
  }

  List<Component> _createUnderwaterCurrentEffect(Vector2 screenSize) {
    final bubbles = <Component>[];
    for (int i = 0; i < 40; i++) {
      final bubble = BubbleComponent(
        position: Vector2(
          (i * 30) % screenSize.x,
          screenSize.y + 10 + (i * 15),
        ),
        size: Vector2.all(2 + (i % 4)),
        riseSpeed: 30 + (i % 20),
        swayAmount: 25 + (i % 15),
      );
      bubbles.add(bubble);
    }
    return bubbles;
  }

  List<Component> _createHumidityEffect(Vector2 screenSize) {
    final mist = <Component>[];
    for (int i = 0; i < 20; i++) {
      final mistParticle = MistComponent(
        position: Vector2(
          (i * 50) % screenSize.x,
          (i * 40) % screenSize.y,
        ),
        size: Vector2.all(20 + (i % 10)),
        opacity: 0.1 + (i % 5) * 0.05,
        driftSpeed: 10 + (i % 10),
      );
      mist.add(mistParticle);
    }
    return mist;
  }

  List<Component> _createGentleBreezeEffect(Vector2 screenSize) {
    final leaves = <Component>[];
    for (int i = 0; i < 25; i++) {
      final leaf = LeafComponent(
        position: Vector2(
          -10 - (i * 30),
          (i * 25) % screenSize.y,
        ),
        size: Vector2(3, 5 + (i % 3)),
        moveSpeed: 40 + (i % 30),
        swayAmount: 30 + (i % 20),
        leafType: i % 3,
      );
      leaves.add(leaf);
    }
    return leaves;
  }

  // Special Effects Implementation
  Component _createRetroFilterEffect(Vector2 screenSize) {
    return RetroFilterComponent(screenSize: screenSize);
  }

  List<Component> _createPixelDustEffect(Vector2 screenSize) {
    final dust = <Component>[];
    for (int i = 0; i < 20; i++) {
      final pixel = PixelDustComponent(
        position: Vector2(
          (i * 40) % screenSize.x,
          (i * 35) % screenSize.y,
        ),
        size: Vector2.all(2),
        flickerSpeed: 0.5 + (i % 10) * 0.1,
      );
      dust.add(pixel);
    }
    return dust;
  }

  Component _createHeatShimmerEffect(Vector2 screenSize) {
    return HeatShimmerComponent(screenSize: screenSize);
  }

  List<Component> _createMirageEffect(Vector2 screenSize) {
    final mirages = <Component>[];
    for (int i = 0; i < 5; i++) {
      final mirage = MirageComponent(
        position: Vector2(
          (i * 150) % screenSize.x,
          screenSize.y * 0.7,
        ),
        size: Vector2(80 + (i % 40), 20),
        opacity: 0.3 + (i % 5) * 0.1,
      );
      mirages.add(mirage);
    }
    return mirages;
  }

  List<Component> _createFirefliesEffect(Vector2 screenSize) {
    final fireflies = <Component>[];
    for (int i = 0; i < 15; i++) {
      final firefly = FireflyComponent(
        position: Vector2(
          (i * 60) % screenSize.x,
          (i * 50) % screenSize.y,
        ),
        size: Vector2.all(2),
        glowIntensity: 0.5 + (i % 5) * 0.1,
        movePattern: i % 3,
      );
      fireflies.add(firefly);
    }
    return fireflies;
  }

  List<Component> _createFallingLeavesEffect(Vector2 screenSize) {
    final leaves = <Component>[];
    for (int i = 0; i < 30; i++) {
      final leaf = FallingLeafComponent(
        position: Vector2(
          (i * 25) % screenSize.x,
          -10 - (i * 20),
        ),
        size: Vector2(4, 6 + (i % 4)),
        fallSpeed: 25 + (i % 20),
        rotationSpeed: 1 + (i % 3),
        leafColor: i % 4,
      );
      leaves.add(leaf);
    }
    return leaves;
  }

  Component _createNeonGlowEffect(Vector2 screenSize) {
    return NeonGlowComponent(screenSize: screenSize);
  }

  List<Component> _createTrafficLightsEffect(Vector2 screenSize) {
    final lights = <Component>[];
    for (int i = 0; i < 8; i++) {
      final light = TrafficLightComponent(
        position: Vector2(
          (i * 100) % screenSize.x,
          screenSize.y * 0.8,
        ),
        size: Vector2.all(8),
        lightType: i % 3,
        blinkSpeed: 1.0 + (i % 3) * 0.5,
      );
      lights.add(light);
    }
    return lights;
  }

  List<Component> _createBubblesEffect(Vector2 screenSize) {
    final bubbles = <Component>[];
    for (int i = 0; i < 25; i++) {
      final bubble = BubbleComponent(
        position: Vector2(
          (i * 35) % screenSize.x,
          screenSize.y + 10 + (i * 25),
        ),
        size: Vector2.all(3 + (i % 3)),
        riseSpeed: 35 + (i % 25),
        swayAmount: 20 + (i % 10),
      );
      bubbles.add(bubble);
    }
    return bubbles;
  }

  Component _createUnderwaterGlowEffect(Vector2 screenSize) {
    return UnderwaterGlowComponent(screenSize: screenSize);
  }

  List<Component> _createStarfieldEffect(Vector2 screenSize) {
    final stars = <Component>[];
    for (int i = 0; i < 100; i++) {
      final star = StarComponent(
        position: Vector2(
          (i * 8) % screenSize.x,
          (i * 10) % screenSize.y,
        ),
        size: Vector2.all(1 + (i % 2)),
        twinkleSpeed: 0.5 + (i % 10) * 0.1,
        brightness: 0.3 + (i % 7) * 0.1,
      );
      stars.add(star);
    }
    return stars;
  }

  Component _createZeroGravityEffect() {
    return ZeroGravityComponent();
  }

  Component _createRainbowTrailEffect() {
    return RainbowTrailComponent();
  }
  
  List<Component> _createCandySparkleEffect(Vector2 screenSize) {
    final sparkles = <Component>[];
    for (int i = 0; i < 35; i++) {
      final sparkle = CandySparkleComponent(
        position: Vector2(
          (i * 22) % screenSize.x,
          (i * 18) % screenSize.y,
        ),
        size: Vector2.all(2),
        sparkleColor: i % 6,
        sparkleSpeed: 2.0 + (i % 5) * 0.3,
      );
      sparkles.add(sparkle);
    }
    return sparkles;
  }

  List<Component> _createAuroraLightsEffect(Vector2 screenSize) {
    final auroras = <Component>[];
    for (int i = 0; i < 6; i++) {
      final aurora = AuroraComponent(
        position: Vector2(0, screenSize.y * 0.1),
        size: Vector2(screenSize.x, screenSize.y * 0.3),
        waveAmplitude: 20 + (i % 3) * 10,
        waveSpeed: 0.5 + (i % 3) * 0.2,
        auroraColor: i % 3,
      );
      auroras.add(aurora);
    }
    return auroras;
  }

  Component _createIceReflectionEffect(Vector2 screenSize) {
    return IceReflectionComponent(screenSize: screenSize);
  }

  List<Component> _createVineSwingEffect(Vector2 screenSize) {
    final vines = <Component>[];
    for (int i = 0; i < 10; i++) {
      final vine = VineComponent(
        position: Vector2(
          (i * 80) % screenSize.x,
          0,
        ),
        length: 100 + (i % 50),
        swayAmount: 15 + (i % 10),
        swaySpeed: 0.8 + (i % 5) * 0.2,
      );
      vines.add(vine);
    }
    return vines;
  }

  Component _createAncientGlowEffect(Vector2 screenSize) {
    return AncientGlowComponent(screenSize: screenSize);
  }

  Component _createLavaGlowEffect(Vector2 screenSize) {
    return LavaGlowComponent(screenSize: screenSize);
  }

  List<Component> _createAshFallEffect(Vector2 screenSize) {
    final ash = <Component>[];
    for (int i = 0; i < 40; i++) {
      final ashParticle = AshParticleComponent(
        position: Vector2(
          (i * 18) % screenSize.x,
          -8 - (i * 15),
        ),
        size: Vector2.all(1 + (i % 2)),
        fallSpeed: 15 + (i % 12),
        swayAmount: 10 + (i % 8),
      );
      ash.add(ashParticle);
    }
    return ash;
  }

  /// Clear all active effects
  void clearAllEffects() {
    _activeEffects.clear();
  }
}

// Individual Effect Component Classes
class SnowflakeComponent extends PositionComponent {
  final double fallSpeed;
  final double swayAmount;
  double _time = 0;

  SnowflakeComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
    required this.swayAmount,
  }) : super(position: position, size: size);

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

class RaindropComponent extends PositionComponent {
  final double fallSpeed;

  RaindropComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
  }
}

class SandParticleComponent extends PositionComponent {
  final double moveSpeed;
  final Vector2 direction;

  SandParticleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.moveSpeed,
    required this.direction,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.yellow.withOpacity(0.4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * moveSpeed * dt;
  }
}

class AshParticleComponent extends PositionComponent {
  final double fallSpeed;
  final double swayAmount;
  double _time = 0;

  AshParticleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
    required this.swayAmount,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y += fallSpeed * dt;
    position.x += swayAmount * dt * 0.3;
  }
}

class CandyRainComponent extends PositionComponent {
  final double fallSpeed;
  final double rotationSpeed;
  final int candyType;
  double _rotation = 0;

  CandyRainComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
    required this.rotationSpeed,
    required this.candyType,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.yellow,
    ];
    final paint = Paint()..color = colors[candyType].withOpacity(0.8);
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(_rotation);
    canvas.drawRect(Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y), paint);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
    _rotation += rotationSpeed * dt;
  }
}

class MeteorComponent extends PositionComponent {
  final double fallSpeed;
  final double trailLength;

  MeteorComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
    required this.trailLength,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withOpacity(0.9),
        Colors.orange.withOpacity(0.7),
        Colors.red.withOpacity(0.3),
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
  }
}

class BubbleComponent extends PositionComponent {
  final double riseSpeed;
  final double swayAmount;
  double _time = 0;

  BubbleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.riseSpeed,
    required this.swayAmount,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y -= riseSpeed * dt;
    position.x += swayAmount * dt * 0.5;
  }
}

class MistComponent extends PositionComponent {
  final double opacity;
  final double driftSpeed;
  double _time = 0;

  MistComponent({
    required Vector2 position,
    required Vector2 size,
    required this.opacity,
    required this.driftSpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.x += driftSpeed * dt;
  }
}

class LeafComponent extends PositionComponent {
  final double moveSpeed;
  final double swayAmount;
  final int leafType;
  double _time = 0;

  LeafComponent({
    required Vector2 position,
    required Vector2 size,
    required this.moveSpeed,
    required this.swayAmount,
    required this.leafType,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.green,
      Colors.brown,
      Colors.orange,
    ];
    final paint = Paint()..color = colors[leafType].withOpacity(0.7);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.x += moveSpeed * dt;
    position.y += swayAmount * dt * 0.3;
  }
}

// Placeholder classes for special effects (would need full implementation)
class RetroFilterComponent extends Component {
  final Vector2 screenSize;
  RetroFilterComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        Colors.brown.withOpacity(0.1),
        BlendMode.multiply,
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class HeatShimmerComponent extends Component {
  final Vector2 screenSize;
  HeatShimmerComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.05);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class NeonGlowComponent extends Component {
  final Vector2 screenSize;
  NeonGlowComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.pink.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class UnderwaterGlowComponent extends Component {
  final Vector2 screenSize;
  UnderwaterGlowComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class ZeroGravityComponent extends Component {
  @override
  void update(double dt) {
    super.update(dt);
    // Would affect physics of game objects
  }
}

class RainbowTrailComponent extends Component {
  @override
  void render(Canvas canvas) {
    // Would create rainbow trail effect behind player
  }
}

class IceReflectionComponent extends Component {
  final Vector2 screenSize;
  IceReflectionComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class AncientGlowComponent extends Component {
  final Vector2 screenSize;
  AncientGlowComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

class LavaGlowComponent extends Component {
  final Vector2 screenSize;
  LavaGlowComponent({required this.screenSize});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.15);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);
  }
}

// Additional effect components (simplified implementations)
class PixelDustComponent extends PositionComponent {
  final double flickerSpeed;
  double _time = 0;

  PixelDustComponent({
    required Vector2 position,
    required Vector2 size,
    required this.flickerSpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final opacity = (sin(_time * flickerSpeed) + 1) / 2;
    final paint = Paint()..color = Colors.white.withOpacity(opacity * 0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

class MirageComponent extends PositionComponent {
  final double opacity;

  MirageComponent({
    required Vector2 position,
    required Vector2 size,
    required this.opacity,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.yellow.withOpacity(opacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }
}

class FireflyComponent extends PositionComponent {
  final double glowIntensity;
  final int movePattern;
  double _time = 0;

  FireflyComponent({
    required Vector2 position,
    required Vector2 size,
    required this.glowIntensity,
    required this.movePattern,
  }) : super(position: position, size: size);

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
    position.x += sin(_time * movePattern) * dt * 20;
    position.y += cos(_time * movePattern) * dt * 15;
  }
}

class FallingLeafComponent extends PositionComponent {
  final double fallSpeed;
  final double rotationSpeed;
  final int leafColor;
  double _rotation = 0;

  FallingLeafComponent({
    required Vector2 position,
    required Vector2 size,
    required this.fallSpeed,
    required this.rotationSpeed,
    required this.leafColor,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.brown,
    ];
    final paint = Paint()..color = colors[leafColor].withOpacity(0.8);
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(_rotation);
    canvas.drawRect(Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y), paint);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
    position.x += sin(_rotation) * dt * 10;
    _rotation += rotationSpeed * dt;
  }
}

class TrafficLightComponent extends PositionComponent {
  final int lightType;
  final double blinkSpeed;
  double _time = 0;

  TrafficLightComponent({
    required Vector2 position,
    required Vector2 size,
    required this.lightType,
    required this.blinkSpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
    ];
    final opacity = (sin(_time * blinkSpeed) + 1) / 2;
    final paint = Paint()..color = colors[lightType].withOpacity(opacity);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

class StarComponent extends PositionComponent {
  final double twinkleSpeed;
  final double brightness;
  double _time = 0;

  StarComponent({
    required Vector2 position,
    required Vector2 size,
    required this.twinkleSpeed,
    required this.brightness,
  }) : super(position: position, size: size);

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
  final int sparkleColor;
  final double sparkleSpeed;
  double _time = 0;

  CandySparkleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.sparkleColor,
    required this.sparkleSpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
    ];
    final opacity = (sin(_time * sparkleSpeed) + 1) / 2;
    final paint = Paint()..color = colors[sparkleColor].withOpacity(opacity);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

class AuroraComponent extends PositionComponent {
  final double waveAmplitude;
  final double waveSpeed;
  final int auroraColor;
  double _time = 0;

  AuroraComponent({
    required Vector2 position,
    required Vector2 size,
    required this.waveAmplitude,
    required this.waveSpeed,
    required this.auroraColor,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    final paint = Paint()..color = colors[auroraColor].withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y += sin(_time * waveSpeed) * waveAmplitude * dt;
  }
}

class VineComponent extends PositionComponent {
  final double length;
  final double swayAmount;
  final double swaySpeed;
  double _time = 0;

  VineComponent({
    required Vector2 position,
    required Vector2 size,
    required this.length,
    required this.swayAmount,
    required this.swaySpeed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, length),
      paint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.x += sin(_time * swaySpeed) * swayAmount * dt;
  }
}
