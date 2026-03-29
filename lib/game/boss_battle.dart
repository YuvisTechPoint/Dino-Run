import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../models/game_theme.dart';
import '../models/player_profile.dart';

/// Boss battle system with epic encounters
enum BossType {
  giantScorpion,    // Desert boss
  ancientTree,     // Forest boss
  cyberDragon,     // City boss
  kraken,          // Ocean boss
  alienWarlord,    // Space boss
  candyDragon,     // Candy boss
  iceGiant,        // Winter boss
  jungleBeast,     // Jungle boss
  lavaMonster,     // Volcano boss
}

/// Boss phases and attack patterns
enum BossPhase {
  phase1,           // Initial phase (100-70% health)
  phase2,           // Enraged phase (70-30% health)
  phase3,           // Desperate phase (30-10% health)
  finalPhase,       // Final desperate attacks (10-0% health)
}

/// Attack patterns for bosses
enum AttackPattern {
  directCharge,     // Boss charges directly at player
  projectileRain,   // Shoots projectiles from above
  groundSlam,       // Slams ground creating shockwaves
  summonMinions,    // Summons smaller enemies
  laserBeam,        // Fires laser beam across screen
  whirlwind,         // Creates damaging whirlwind
  meteorShower,     // Calls down meteors
  timeBomb,         // Places time bombs
}

/// Boss configuration with theme-specific properties
class BossConfig {
  final String name;
  final BossType type;
  final String description;
  final int maxHealth;
  final double speed;
  final Color primaryColor;
  final Color secondaryColor;
  final List<AttackPattern> availableAttacks;
  final Map<BossPhase, List<AttackPattern>> phaseAttacks;
  final String spritePath;
  final List<String> soundEffects;
  final int rewardScore;
  final int rewardCoins;
  final String specialReward;

  BossConfig({
    required this.name,
    required this.type,
    required this.description,
    required this.maxHealth,
    required this.speed,
    required this.primaryColor,
    required this.secondaryColor,
    required this.availableAttacks,
    required this.phaseAttacks,
    required this.spritePath,
    required this.soundEffects,
    required this.rewardScore,
    required this.rewardCoins,
    this.specialReward = '',
  });

  /// Get boss config for theme
  static BossConfig getBossForTheme(GameThemeType themeType) {
    switch (themeType) {
      case GameThemeType.desert:
        return BossConfig(
          name: 'Giant Sand Scorpion',
          type: BossType.giantScorpion,
          description: 'Ancient guardian of the desert sands',
          maxHealth: 1000,
          speed: 1.2,
          primaryColor: Colors.orange,
          secondaryColor: Colors.red,
          availableAttacks: [
            AttackPattern.directCharge,
            AttackPattern.groundSlam,
            AttackPattern.projectileRain,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.directCharge],
            BossPhase.phase2: [AttackPattern.directCharge, AttackPattern.groundSlam],
            BossPhase.phase3: [AttackPattern.groundSlam, AttackPattern.projectileRain],
            BossPhase.finalPhase: [AttackPattern.projectileRain, AttackPattern.groundSlam],
          },
          spritePath: 'bosses/scorpion_boss.png',
          soundEffects: ['boss/scorpion_roar.wav', 'boss/scorpion_attack.wav'],
          rewardScore: 5000,
          rewardCoins: 1000,
          specialReward: 'Desert Crown',
        );

      case GameThemeType.forest:
        return BossConfig(
          name: 'Ancient Tree Guardian',
          type: BossType.ancientTree,
          description: 'Protector of the mystical forest',
          maxHealth: 1200,
          speed: 0.8,
          primaryColor: Colors.brown,
          secondaryColor: Colors.green,
          availableAttacks: [
            AttackPattern.groundSlam,
            AttackPattern.summonMinions,
            AttackPattern.whirlwind,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.summonMinions],
            BossPhase.phase2: [AttackPattern.summonMinions, AttackPattern.groundSlam],
            BossPhase.phase3: [AttackPattern.groundSlam, AttackPattern.whirlwind],
            BossPhase.finalPhase: [AttackPattern.whirlwind, AttackPattern.summonMinions],
          },
          spritePath: 'bosses/tree_boss.png',
          soundEffects: ['boss/tree_roar.wav', 'boss/tree_attack.wav'],
          rewardScore: 6000,
          rewardCoins: 1200,
          specialReward: 'Forest Heart',
        );

      case GameThemeType.city:
        return BossConfig(
          name: 'Cyber Dragon',
          type: BossType.cyberDragon,
          description: 'Technological terror of the neon city',
          maxHealth: 1500,
          speed: 1.5,
          primaryColor: Colors.blue,
          secondaryColor: Colors.cyan,
          availableAttacks: [
            AttackPattern.laserBeam,
            AttackPattern.projectileRain,
            AttackPattern.directCharge,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.laserBeam],
            BossPhase.phase2: [AttackPattern.laserBeam, AttackPattern.projectileRain],
            BossPhase.phase3: [AttackPattern.projectileRain, AttackPattern.directCharge],
            BossPhase.finalPhase: [AttackPattern.directCharge, AttackPattern.laserBeam],
          },
          spritePath: 'bosses/cyber_dragon.png',
          soundEffects: ['boss/dragon_roar.wav', 'boss/laser_fire.wav'],
          rewardScore: 7500,
          rewardCoins: 1500,
          specialReward: 'Cyber Core',
        );

      case GameThemeType.ocean:
        return BossConfig(
          name: 'Deep Sea Kraken',
          type: BossType.kraken,
          description: 'Terror of the ocean depths',
          maxHealth: 1300,
          speed: 1.0,
          primaryColor: Colors.blue,
          secondaryColor: Colors.purple,
          availableAttacks: [
            AttackPattern.whirlwind,
            AttackPattern.projectileRain,
            AttackPattern.summonMinions,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.whirlwind],
            BossPhase.phase2: [AttackPattern.whirlwind, AttackPattern.projectileRain],
            BossPhase.phase3: [AttackPattern.projectileRain, AttackPattern.summonMinions],
            BossPhase.finalPhase: [AttackPattern.summonMinions, AttackPattern.whirlwind],
          },
          spritePath: 'bosses/kraken_boss.png',
          soundEffects: ['boss/kraken_roar.wav', 'boss/tentacle_slam.wav'],
          rewardScore: 7000,
          rewardCoins: 1400,
          specialReward: 'Ocean Pearl',
        );

      case GameThemeType.space:
        return BossConfig(
          name: 'Alien Warlord',
          type: BossType.alienWarlord,
          description: 'Supreme commander of the alien fleet',
          maxHealth: 1800,
          speed: 1.3,
          primaryColor: Colors.purple,
          secondaryColor: Colors.green,
          availableAttacks: [
            AttackPattern.laserBeam,
            AttackPattern.meteorShower,
            AttackPattern.summonMinions,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.laserBeam],
            BossPhase.phase2: [AttackPattern.laserBeam, AttackPattern.meteorShower],
            BossPhase.phase3: [AttackPattern.meteorShower, AttackPattern.summonMinions],
            BossPhase.finalPhase: [AttackPattern.summonMinions, AttackPattern.laserBeam],
          },
          spritePath: 'bosses/alien_warlord.png',
          soundEffects: ['boss/alien_roar.wav', 'boss/laser_blast.wav'],
          rewardScore: 10000,
          rewardCoins: 2000,
          specialReward: 'Alien Artifact',
        );

      case GameThemeType.candy:
        return BossConfig(
          name: 'Candy Dragon',
          type: BossType.candyDragon,
          description: 'Sweet but deadly guardian of candy land',
          maxHealth: 1100,
          speed: 1.4,
          primaryColor: Colors.pink,
          secondaryColor: Colors.purple,
          availableAttacks: [
            AttackPattern.projectileRain,
            AttackPattern.whirlwind,
            AttackPattern.timeBomb,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.projectileRain],
            BossPhase.phase2: [AttackPattern.projectileRain, AttackPattern.whirlwind],
            BossPhase.phase3: [AttackPattern.whirlwind, AttackPattern.timeBomb],
            BossPhase.finalPhase: [AttackPattern.timeBomb, AttackPattern.projectileRain],
          },
          spritePath: 'bosses/candy_dragon.png',
          soundEffects: ['boss/dragon_sweet.wav', 'boss/candy_blast.wav'],
          rewardScore: 5500,
          rewardCoins: 1100,
          specialReward: 'Candy Crown',
        );

      case GameThemeType.winter:
        return BossConfig(
          name: 'Ice Giant',
          type: BossType.iceGiant,
          description: 'Frozen monarch of the winter realm',
          maxHealth: 1400,
          speed: 0.9,
          primaryColor: Colors.lightBlue,
          secondaryColor: Colors.white,
          availableAttacks: [
            AttackPattern.groundSlam,
            AttackPattern.projectileRain,
            AttackPattern.whirlwind,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.groundSlam],
            BossPhase.phase2: [AttackPattern.groundSlam, AttackPattern.projectileRain],
            BossPhase.phase3: [AttackPattern.projectileRain, AttackPattern.whirlwind],
            BossPhase.finalPhase: [AttackPattern.whirlwind, AttackPattern.groundSlam],
          },
          spritePath: 'bosses/ice_giant.png',
          soundEffects: ['boss/giant_roar.wav', 'boss/ice_crack.wav'],
          rewardScore: 8000,
          rewardCoins: 1600,
          specialReward: 'Ice Crown',
        );

      case GameThemeType.jungle:
        return BossConfig(
          name: 'Jungle Beast',
          type: BossType.jungleBeast,
          description: 'Primal hunter of the ancient jungle',
          maxHealth: 1250,
          speed: 1.6,
          primaryColor: Colors.green,
          secondaryColor: Colors.brown,
          availableAttacks: [
            AttackPattern.directCharge,
            AttackPattern.summonMinions,
            AttackPattern.whirlwind,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.directCharge],
            BossPhase.phase2: [AttackPattern.directCharge, AttackPattern.summonMinions],
            BossPhase.phase3: [AttackPattern.summonMinions, AttackPattern.whirlwind],
            BossPhase.finalPhase: [AttackPattern.whirlwind, AttackPattern.directCharge],
          },
          spritePath: 'bosses/jungle_beast.png',
          soundEffects: ['boss/beast_roar.wav', 'boss/vine_attack.wav'],
          rewardScore: 6500,
          rewardCoins: 1300,
          specialReward: 'Jungle Totem',
        );

      case GameThemeType.volcano:
        return BossConfig(
          name: 'Lava Monster',
          type: BossType.lavaMonster,
          description: 'Living embodiment of volcanic fury',
          maxHealth: 1600,
          speed: 1.1,
          primaryColor: Colors.red,
          secondaryColor: Colors.orange,
          availableAttacks: [
            AttackPattern.groundSlam,
            AttackPattern.meteorShower,
            AttackPattern.laserBeam,
          ],
          phaseAttacks: {
            BossPhase.phase1: [AttackPattern.groundSlam],
            BossPhase.phase2: [AttackPattern.groundSlam, AttackPattern.meteorShower],
            BossPhase.phase3: [AttackPattern.meteorShower, AttackPattern.laserBeam],
            BossPhase.finalPhase: [AttackPattern.laserBeam, AttackPattern.groundSlam],
          },
          spritePath: 'bosses/lava_monster.png',
          soundEffects: ['boss/monster_roar.wav', 'boss/lava_eruption.wav'],
          rewardScore: 9000,
          rewardCoins: 1800,
          specialReward: 'Volcano Heart',
        );

      default:
        return BossConfig(
          name: 'Mystery Boss',
          type: BossType.giantScorpion,
          description: 'An unknown challenger',
          maxHealth: 1000,
          speed: 1.0,
          primaryColor: Colors.grey,
          secondaryColor: Colors.black,
          availableAttacks: [AttackPattern.directCharge],
          phaseAttacks: {BossPhase.phase1: [AttackPattern.directCharge]},
          spritePath: 'bosses/mystery_boss.png',
          soundEffects: ['boss/mystery_roar.wav'],
          rewardScore: 5000,
          rewardCoins: 1000,
        );
    }
  }
}

/// Boss battle component
class BossBattle extends Component {
  late BossConfig config;
  int currentHealth;
  BossPhase currentPhase = BossPhase.phase1;
  double attackCooldown = 0.0;
  double phaseTransitionTime = 0.0;
  bool isDefeated = false;
  Vector2 position;
  Vector2 size;
  PlayerProfile? playerProfile;

  BossBattle({
    required this.config,
    required this.position,
    this.size = const Vector2(200, 150),
  }) : currentHealth = config.maxHealth;

  @override
  Future<void> onLoad() async {
    // Load boss sprite and sounds
    // Initialize boss AI
    _startBossAI();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (isDefeated) return;
    
    // Update attack cooldown
    if (attackCooldown > 0) {
      attackCooldown -= dt;
    }
    
    // Check for phase transitions
    _checkPhaseTransition();
    
    // Execute AI behavior
    _updateAI(dt);
  }

  @override
  void render(Canvas canvas) {
    // Render boss sprite
    final paint = Paint()
      ..color = config.primaryColor
      ..style = PaintingStyle.fill;
    
    // Simple rectangle representation (would be sprite in real implementation)
    canvas.drawRect(
      Rect.fromLTWH(position.x, position.y, size.x, size.y),
      paint,
    );
    
    // Render health bar
    _renderHealthBar(canvas);
  }

  void _renderHealthBar(Canvas canvas) {
    const barWidth = 200.0;
    const barHeight = 20.0;
    const barY = 50.0;
    
    // Background
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawRect(
      Rect.fromLTWH(0, barY, barWidth, barHeight),
      bgPaint,
    );
    
    // Health fill
    final healthPercentage = currentHealth / config.maxHealth;
    final healthPaint = Paint()
      ..color = _getHealthBarColor(healthPercentage)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, barY, barWidth * healthPercentage, barHeight),
      healthPaint,
    );
    
    // Border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRect(
      Rect.fromLTWH(0, barY, barWidth, barHeight),
      borderPaint,
    );
    
    // Boss name
    final textPainter = TextPainter(
      text: TextSpan(
        text: config.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, barY - 25));
  }

  Color _getHealthBarColor(double percentage) {
    if (percentage > 0.6) return Colors.green;
    if (percentage > 0.3) return Colors.orange;
    return Colors.red;
  }

  void _checkPhaseTransition() {
    final healthPercentage = currentHealth / config.maxHealth;
    
    BossPhase newPhase;
    if (healthPercentage > 0.7) {
      newPhase = BossPhase.phase1;
    } else if (healthPercentage > 0.3) {
      newPhase = BossPhase.phase2;
    } else if (healthPercentage > 0.1) {
      newPhase = BossPhase.phase3;
    } else {
      newPhase = BossPhase.finalPhase;
    }
    
    if (newPhase != currentPhase) {
      currentPhase = newPhase;
      _onPhaseTransition();
    }
  }

  void _onPhaseTransition() {
    // Visual effects for phase transition
    // Speed up attacks, change patterns, etc.
    phaseTransitionTime = 2.0; // 2 seconds of transition effects
    
    // Reset attack cooldown for immediate new attack
    attackCooldown = 0.5;
  }

  void _updateAI(double dt) {
    if (phaseTransitionTime > 0) {
      phaseTransitionTime -= dt;
      return; // Don't attack during transition
    }
    
    // Execute attack pattern based on current phase
    if (attackCooldown <= 0) {
      _executeAttack();
    }
  }

  void _executeAttack() {
    final availableAttacks = config.phaseAttacks[currentPhase] ?? [];
    if (availableAttacks.isEmpty) return;
    
    // Select random attack from available patterns
    final attack = availableAttacks[DateTime.now().millisecond % availableAttacks.length];
    
    switch (attack) {
      case AttackPattern.directCharge:
        _executeDirectCharge();
        break;
      case AttackPattern.projectileRain:
        _executeProjectileRain();
        break;
      case AttackPattern.groundSlam:
        _executeGroundSlam();
        break;
      case AttackPattern.summonMinions:
        _executeSummonMinions();
        break;
      case AttackPattern.laserBeam:
        _executeLaserBeam();
        break;
      case AttackPattern.whirlwind:
        _executeWhirlwind();
        break;
      case AttackPattern.meteorShower:
        _executeMeteorShower();
        break;
      case AttackPattern.timeBomb:
        _executeTimeBomb();
        break;
    }
    
    // Set cooldown based on phase (faster in later phases)
    attackCooldown = _getAttackCooldown();
  }

  double _getAttackCooldown() {
    switch (currentPhase) {
      case BossPhase.phase1:
        return 3.0;
      case BossPhase.phase2:
        return 2.5;
      case BossPhase.phase3:
        return 2.0;
      case BossPhase.finalPhase:
        return 1.5;
    }
  }

  void _executeDirectCharge() {
    // Boss charges directly at player
    // Implementation would move boss towards player position
    print('Boss executes Direct Charge!');
  }

  void _executeProjectileRain() {
    // Boss shoots projectiles from above
    // Implementation would spawn projectile components
    print('Boss executes Projectile Rain!');
  }

  void _executeGroundSlam() {
    // Boss slams ground creating shockwaves
    // Implementation would create shockwave effects
    print('Boss executes Ground Slam!');
  }

  void _executeSummonMinions() {
    // Boss summons smaller enemies
    // Implementation would spawn enemy components
    print('Boss summons Minions!');
  }

  void _executeLaserBeam() {
    // Boss fires laser beam across screen
    // Implementation would create laser effect
    print('Boss fires Laser Beam!');
  }

  void _executeWhirlwind() {
    // Boss creates damaging whirlwind
    // Implementation would create whirlwind effect
    print('Boss creates Whirlwind!');
  }

  void _executeMeteorShower() {
    // Boss calls down meteors
    // Implementation would spawn meteor components
    print('Boss calls Meteor Shower!');
  }

  void _executeTimeBomb() {
    // Boss places time bombs
    // Implementation would spawn bomb components
    print('Boss places Time Bombs!');
  }

  void takeDamage(int damage) {
    currentHealth -= damage;
    
    if (currentHealth <= 0) {
      currentHealth = 0;
      _onDefeated();
    }
  }

  void _onDefeated() {
    isDefeated = true;
    
    // Award rewards
    if (playerProfile != null) {
      playerProfile!.addExperience(config.rewardScore ~/ 10);
      playerProfile!.addCoins(config.rewardCoins);
    }
    
    // Victory effects
    print('Boss defeated! Rewards: ${config.rewardScore} score, ${config.rewardCoins} coins');
    
    // Remove boss from game
    removeFromParent();
  }

  void _startBossAI() {
    // Initialize AI behavior
    // Could include movement patterns, targeting, etc.
  }

  /// Get boss information for UI display
  Map<String, dynamic> getBossInfo() {
    return {
      'name': config.name,
      'description': config.description,
      'maxHealth': config.maxHealth,
      'currentHealth': currentHealth,
      'phase': currentPhase.toString(),
      'type': config.type.toString(),
      'rewards': {
        'score': config.rewardScore,
        'coins': config.rewardCoins,
        'special': config.specialReward,
      },
    };
  }
}

/// Manager for boss battles
class BossBattleManager extends Component {
  BossBattle? currentBoss;
  bool isBossActive = false;
  int bossesDefeated = 0;
  List<String> defeatedBossTypes = [];

  /// Start boss battle for theme
  void startBossBattle(GameThemeType themeType, Vector2 spawnPosition) {
    if (isBossActive) return; // Only one boss at a time
    
    final config = BossConfig.getBossForTheme(themeType);
    currentBoss = BossBattle(
      config: config,
      position: spawnPosition,
    );
    
    isBossActive = true;
    add(currentBoss!);
  }

  /// Handle boss defeat
  void onBossDefeated(BossBattle defeatedBoss) {
    isBossActive = false;
    bossesDefeated++;
    
    if (!defeatedBossTypes.contains(defeatedBoss.config.type.toString())) {
      defeatedBossTypes.add(defeatedBoss.config.type.toString());
    }
    
    currentBoss = null;
  }

  /// Check if boss type is defeated
  bool isBossDefeated(BossType bossType) {
    return defeatedBossTypes.contains(bossType.toString());
  }

  /// Get total boss rewards earned
  int getTotalBossRewards() {
    return bossesDefeated * 1000; // Average reward calculation
  }
}
