import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'skill_tree.g.dart';

/// Skill categories and types
enum SkillCategory {
  speed,           // Movement and agility skills
  defense,         // Health and protection
  offense,         // Combat and scoring
  utility,         // Special abilities and bonuses
  mastery,         // Advanced and specialized skills
}

/// Skill types with different effects
enum SkillType {
  // Speed Skills
  dash,                    // Quick dash forward
  doubleJump,              // Jump again in mid-air
  speedBoost,              // Permanent speed increase
  slide,                   // Slide under obstacles
  wallJump,                // Jump off walls
  
  // Defense Skills
  extraLife,               // Additional life
  damageReduction,         // Reduce damage taken
  shield,                  // Temporary shield
  regeneration,            // Slow health regeneration
  invincibility,           // Brief invincibility after hit
  
  // Offense Skills
  coinMagnet,              // Attract coins from distance
  scoreMultiplier,         // Increase score gained
  enemyStun,               // Stun enemies on contact
  powerUpBoost,            // Enhanced power-up effects
  comboMaster,             // Extend combo duration
  
  // Utility Skills
  treasureFinder,          // Reveal hidden items
  slowTime,                // Slow down game temporarily
  teleport,                // Short range teleport
  radar,                   // Show enemies on minimap
  experienceBoost,         // Gain more experience
  
  // Mastery Skills
  phoenixRise,             // Resurrect once per run
  legendMode,              // All abilities enhanced
  themeMaster,             // Bonus effects in all themes
  perfectRun,              // Start each run with shield
  godMode,                 // Temporary invincibility ability
}

/// Individual skill with requirements and effects
@HiveType(typeId: 7)
class Skill extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final SkillType type;
  
  @HiveField(4)
  final SkillCategory category;
  
  @HiveField(5)
  final int maxLevel;
  
  @HiveField(6)
  final int costPerLevel;
  
  @HiveField(7)
  final List<String> requirements; // Required skills or player level
  
  @HiveField(8)
  final Map<String, double> effects; // Stat modifications per level
  
  @HiveField(9)
  int currentLevel;
  
  @HiveField(10)
  bool isUnlocked;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    this.maxLevel = 5,
    this.costPerLevel = 100,
    this.requirements = const [],
    this.effects = const {},
    this.currentLevel = 0,
    this.isUnlocked = false,
  });

  /// Get all predefined skills
  static List<Skill> getAllSkills() {
    return [
      // Speed Skills
      Skill(
        id: 'dash',
        name: 'Dash',
        description: 'Quick dash forward to avoid danger',
        type: SkillType.dash,
        category: SkillCategory.speed,
        maxLevel: 3,
        costPerLevel: 150,
        effects: {'dashDistance': 100.0, 'dashCooldown': -0.5},
      ),
      
      Skill(
        id: 'double_jump',
        name: 'Double Jump',
        description: 'Jump again in mid-air',
        type: SkillType.doubleJump,
        category: SkillCategory.speed,
        maxLevel: 1,
        costPerLevel: 200,
        effects: {'extraJump': 1.0},
      ),
      
      Skill(
        id: 'speed_boost',
        name: 'Speed Boost',
        description: 'Permanent increase to movement speed',
        type: SkillType.speedBoost,
        category: SkillCategory.speed,
        maxLevel: 5,
        costPerLevel: 100,
        effects: {'speedMultiplier': 0.1},
      ),
      
      Skill(
        id: 'slide',
        name: 'Slide',
        description: 'Slide under obstacles',
        type: SkillType.slide,
        category: SkillCategory.speed,
        maxLevel: 3,
        costPerLevel: 175,
        effects: {'slideDuration': 0.5, 'slideSpeed': 0.2},
      ),
      
      // Defense Skills
      Skill(
        id: 'extra_life',
        name: 'Extra Life',
        description: 'Add an additional life',
        type: SkillType.extraLife,
        category: SkillCategory.defense,
        maxLevel: 3,
        costPerLevel: 300,
        effects: {'extraLives': 1.0},
      ),
      
      Skill(
        id: 'damage_reduction',
        name: 'Damage Reduction',
        description: 'Reduce damage taken by percentage',
        type: SkillType.damageReduction,
        category: SkillCategory.defense,
        maxLevel: 5,
        costPerLevel: 125,
        effects: {'damageReduction': 0.1},
      ),
      
      Skill(
        id: 'shield',
        name: 'Shield',
        description: 'Temporary shield that blocks one hit',
        type: SkillType.shield,
        category: SkillCategory.defense,
        maxLevel: 3,
        costPerLevel: 200,
        effects: {'shieldDuration': 5.0, 'shieldCooldown': -2.0},
      ),
      
      // Offense Skills
      Skill(
        id: 'coin_magnet',
        name: 'Coin Magnet',
        description: 'Attract coins from greater distance',
        type: SkillType.coinMagnet,
        category: SkillCategory.offense,
        maxLevel: 5,
        costPerLevel: 80,
        effects: {'coinMagnetRange': 50.0},
      ),
      
      Skill(
        id: 'score_multiplier',
        name: 'Score Multiplier',
        description: 'Increase score gained by percentage',
        type: SkillType.scoreMultiplier,
        category: SkillCategory.offense,
        maxLevel: 5,
        costPerLevel: 150,
        effects: {'scoreMultiplier': 0.15},
      ),
      
      Skill(
        id: 'enemy_stun',
        name: 'Enemy Stun',
        description: 'Stun enemies on contact',
        type: SkillType.enemyStun,
        category: SkillCategory.offense,
        maxLevel: 3,
        costPerLevel: 180,
        effects: {'stunDuration': 1.0, 'stunChance': 0.2},
      ),
      
      // Utility Skills
      Skill(
        id: 'treasure_finder',
        name: 'Treasure Finder',
        description: 'Reveal hidden treasures and items',
        type: SkillType.treasureFinder,
        category: SkillCategory.utility,
        maxLevel: 3,
        costPerLevel: 160,
        effects: {'revealRange': 100.0, 'revealChance': 0.3},
      ),
      
      Skill(
        id: 'slow_time',
        name: 'Slow Time',
        description: 'Slow down time temporarily',
        type: SkillType.slowTime,
        category: SkillCategory.utility,
        maxLevel: 3,
        costPerLevel: 250,
        effects: {'slowDuration': 3.0, 'slowFactor': 0.5},
      ),
      
      Skill(
        id: 'experience_boost',
        name: 'Experience Boost',
        description: 'Gain more experience from all activities',
        type: SkillType.experienceBoost,
        category: SkillCategory.utility,
        maxLevel: 5,
        costPerLevel: 120,
        effects: {'experienceMultiplier': 0.2},
      ),
      
      // Mastery Skills
      Skill(
        id: 'phoenix_rise',
        name: 'Phoenix Rise',
        description: 'Resurrect once per run when defeated',
        type: SkillType.phoenixRise,
        category: SkillCategory.mastery,
        maxLevel: 1,
        costPerLevel: 1000,
        requirements: ['player_level_20'],
        effects: {'resurrection': 1.0},
      ),
      
      Skill(
        id: 'legend_mode',
        name: 'Legend Mode',
        description: 'All abilities enhanced when health is full',
        type: SkillType.legendMode,
        category: SkillCategory.mastery,
        maxLevel: 3,
        costPerLevel: 500,
        requirements: ['player_level_30'],
        effects: {'legendMultiplier': 0.25},
      ),
      
      Skill(
        id: 'theme_master',
        name: 'Theme Master',
        description: 'Bonus effects in all themes',
        type: SkillType.themeMaster,
        category: SkillCategory.mastery,
        maxLevel: 5,
        costPerLevel: 200,
        requirements: ['player_level_15'],
        effects: {'themeBonus': 0.1},
      ),
    ];
  }

  /// Get skill icon
  IconData getSkillIcon() {
    switch (type) {
      case SkillType.dash:
        return Icons.flash_on;
      case SkillType.doubleJump:
        return Icons.arrow_upward;
      case SkillType.speedBoost:
        return Icons.speed;
      case SkillType.slide:
        return Icons.arrow_downward;
      case SkillType.wallJump:
        return Icons.swap_vert;
      case SkillType.extraLife:
        return Icons.favorite;
      case SkillType.damageReduction:
        return Icons.security;
      case SkillType.shield:
        return Icons.shield;
      case SkillType.regeneration:
        return Icons.healing;
      case SkillType.invincibility:
        return Icons.star;
      case SkillType.coinMagnet:
        return Icons.monetization_on;
      case SkillType.scoreMultiplier:
        return Icons.scoreboard;
      case SkillType.enemyStun:
        return Icons.gavel;
      case SkillType.powerUpBoost:
        return Icons.bolt;
      case SkillType.comboMaster:
        return Icons.local_fire_department;
      case SkillType.treasureFinder:
        return Icons.search;
      case SkillType.slowTime:
        return Icons.hourglass_empty;
      case SkillType.teleport:
        return Icons.swap_horiz;
      case SkillType.radar:
        return Icons.radar;
      case SkillType.experienceBoost:
        return Icons.trending_up;
      case SkillType.phoenixRise:
        return Icons.local_fire_department;
      case SkillType.legendMode:
        return Icons.military_tech;
      case SkillType.themeMaster:
        return Icons.palette;
      case SkillType.perfectRun:
        return Icons.star_rate;
      case SkillType.godMode:
        return Icons.flash_on;
    }
  }

  /// Get category color
  Color getCategoryColor() {
    switch (category) {
      case SkillCategory.speed:
        return Colors.blue;
      case SkillCategory.defense:
        return Colors.green;
      case SkillCategory.offense:
        return Colors.red;
      case SkillCategory.utility:
        return Colors.purple;
      case SkillCategory.mastery:
        return Colors.orange;
    }
  }

  /// Get total cost to upgrade to max level
  int getTotalCost() {
    return costPerLevel * maxLevel;
  }

  /// Get cost for next level
  int getNextLevelCost() {
    if (currentLevel >= maxLevel) return 0;
    return costPerLevel * (currentLevel + 1);
  }

  /// Check if skill can be upgraded
  bool canUpgrade(int playerCoins, int playerLevel) {
    if (currentLevel >= maxLevel) return false;
    if (playerCoins < getNextLevelCost()) return false;
    
    // Check requirements
    for (final requirement in requirements) {
      if (requirement.startsWith('player_level_')) {
        final requiredLevel = int.parse(requirement.split('_').last);
        if (playerLevel < requiredLevel) return false;
      }
      // Add other requirement checks as needed
    }
    
    return true;
  }

  /// Upgrade skill
  bool upgradeSkill(int playerCoins) {
    if (!canUpgrade(playerCoins, 0)) return false;
    
    currentLevel++;
    if (currentLevel == 1) {
      isUnlocked = true;
    }
    
    notifyListeners();
    save();
    return true;
  }

  /// Get current effect value
  double getCurrentEffect(String effectName) {
    final baseValue = effects[effectName] ?? 0.0;
    return baseValue * currentLevel;
  }

  /// Get skill description with current stats
  String getDetailedDescription() {
    String detailed = description;
    
    for (final entry in effects.entries) {
      final currentValue = getCurrentEffect(entry.key);
      if (currentValue > 0) {
        detailed += '\n${_formatEffect(entry.key, currentValue)}';
      }
    }
    
    return detailed;
  }

  /// Format effect for display
  String _formatEffect(String effectName, double value) {
    switch (effectName) {
      case 'dashDistance':
        return 'Dash Range: +${value.toInt()}px';
      case 'dashCooldown':
        return 'Cooldown: ${value > 0 ? '+' : ''}${value.toInt()}s';
      case 'extraJump':
        return 'Extra Jumps: +${value.toInt()}';
      case 'speedMultiplier':
        return 'Speed: +${(value * 100).toInt()}%';
      case 'slideDuration':
        return 'Slide Duration: +${value.toInt()}s';
      case 'slideSpeed':
        return 'Slide Speed: +${(value * 100).toInt()}%';
      case 'extraLives':
        return 'Extra Lives: +${value.toInt()}';
      case 'damageReduction':
        return 'Damage Reduction: +${(value * 100).toInt()}%';
      case 'shieldDuration':
        return 'Shield Duration: +${value.toInt()}s';
      case 'shieldCooldown':
        return 'Shield Cooldown: ${value > 0 ? '+' : ''}${value.toInt()}s';
      case 'coinMagnetRange':
        return 'Coin Range: +${value.toInt()}px';
      case 'scoreMultiplier':
        return 'Score: +${(value * 100).toInt()}%';
      case 'stunDuration':
        return 'Stun Duration: +${value.toInt()}s';
      case 'stunChance':
        return 'Stun Chance: +${(value * 100).toInt()}%';
      case 'revealRange':
        return 'Reveal Range: +${value.toInt()}px';
      case 'revealChance':
        return 'Reveal Chance: +${(value * 100).toInt()}%';
      case 'slowDuration':
        return 'Slow Duration: +${value.toInt()}s';
      case 'slowFactor':
        return 'Slow Power: ${((1 - value) * 100).toInt()}%';
      case 'experienceMultiplier':
        return 'Experience: +${(value * 100).toInt()}%';
      case 'resurrection':
        return 'Resurrection: ${value > 0 ? 'Yes' : 'No'}';
      case 'legendMultiplier':
        return 'Legend Bonus: +${(value * 100).toInt()}%';
      case 'themeBonus':
        return 'Theme Bonus: +${(value * 100).toInt()}%';
      default:
        return '$effectName: $value';
    }
  }

  /// Get progress percentage
  double getProgress() {
    return currentLevel / maxLevel;
  }
}

/// Manager for all skills and skill tree
class SkillTreeManager extends ChangeNotifier {
  Map<String, Skill> _skills = {};
  int _skillPoints = 0;

  Map<String, Skill> get skills => Map.unmodifiable(_skills);
  int get skillPoints => _skillPoints;

  SkillTreeManager() {
    _initializeSkills();
  }

  /// Initialize all skills
  void _initializeSkills() {
    final allSkills = Skill.getAllSkills();
    for (final skill in allSkills) {
      _skills[skill.id] = skill;
    }
  }

  /// Add skill points (from level ups or rewards)
  void addSkillPoints(int points) {
    _skillPoints += points;
    notifyListeners();
  }

  /// Spend skill points to upgrade skill
  bool upgradeSkill(String skillId, int playerCoins, int playerLevel) {
    final skill = _skills[skillId];
    if (skill == null) return false;

    final cost = skill.getNextLevelCost();
    if (playerCoins >= cost && skill.canUpgrade(playerCoins, playerLevel)) {
      if (skill.upgradeSkill(playerCoins)) {
        notifyListeners();
        return true;
      }
    }
    
    return false;
  }

  /// Get skills by category
  List<Skill> getSkillsByCategory(SkillCategory category) {
    return _skills.values
        .where((skill) => skill.category == category)
        .toList();
  }

  /// Get unlocked skills
  List<Skill> getUnlockedSkills() {
    return _skills.values
        .where((skill) => skill.isUnlocked)
        .toList();
  }

  /// Get total skill level
  int getTotalSkillLevel() {
    return _skills.values
        .fold(0, (sum, skill) => sum + skill.currentLevel);
  }

  /// Get skill effect value
  double getSkillEffect(SkillType skillType, String effectName) {
    final skill = _skills.values
        .where((s) => s.type == skillType)
        .firstOrNull;
    
    return skill?.getCurrentEffect(effectName) ?? 0.0;
  }

  /// Check if skill is unlocked
  bool isSkillUnlocked(String skillId) {
    return _skills[skillId]?.isUnlocked ?? false;
  }

  /// Get skill by ID
  Skill? getSkillById(String skillId) {
    return _skills[skillId];
  }
}
