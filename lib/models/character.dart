import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'character.g.dart';

/// Character types and abilities
enum CharacterType {
  dinoClassic,    // Balanced stats
  dinoSpeed,      // High speed, low health
  dinoTank,       // High health, low speed
  dinoMystic,     // Special abilities
  dinoScout,      // High jump, detection
  dinoWarrior,    // Combat focused
  dinoExplorer,   // Bonus coins
  dinoPhoenix,    // Resurrection ability
}

/// Character with unique abilities and stats
@HiveType(typeId: 5)
class Character extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final CharacterType type;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final int baseHealth;
  
  @HiveField(5)
  final double baseSpeed;
  
  @HiveField(6)
  final double baseJumpHeight;
  
  @HiveField(7)
  final String spritePath;
  
  @HiveField(8)
  final int unlockCost;
  
  @HiveField(9)
  final String requirement;
  
  @HiveField(10)
  bool isUnlocked;
  
  @HiveField(11)
  int currentLevel;
  
  @HiveField(12)
  int experience;
  
  @HiveField(13)
  Map<String, bool> unlockedAbilities = {};

  Character({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.baseHealth,
    required this.baseSpeed,
    required this.baseJumpHeight,
    required this.spritePath,
    this.unlockCost = 0,
    this.requirement = 'Default',
    this.isUnlocked = false,
    this.currentLevel = 1,
    this.experience = 0,
  });

  /// Get all predefined characters
  static List<Character> getPredefinedCharacters() {
    return [
      Character(
        id: 'dino_classic',
        name: 'Classic Dino',
        type: CharacterType.dinoClassic,
        description: 'Balanced stats, perfect for beginners',
        baseHealth: 5,
        baseSpeed: 1.0,
        baseJumpHeight: 1.0,
        spritePath: 'DinoSprites - tard.png',
        unlockCost: 0,
        requirement: 'Default',
        isUnlocked: true,
      ),
      
      Character(
        id: 'dino_speed',
        name: 'Speed Dino',
        type: CharacterType.dinoSpeed,
        description: 'Lightning fast but fragile',
        baseHealth: 3,
        baseSpeed: 1.5,
        baseJumpHeight: 1.2,
        spritePath: 'characters/dino_speed.png',
        unlockCost: 500,
        requirement: 'Reach level 10',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_tank',
        name: 'Tank Dino',
        type: CharacterType.dinoTank,
        description: 'Slow but durable',
        baseHealth: 8,
        baseSpeed: 0.8,
        baseJumpHeight: 0.8,
        spritePath: 'characters/dino_tank.png',
        unlockCost: 750,
        requirement: 'Complete 50 runs',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_mystic',
        name: 'Mystic Dino',
        type: CharacterType.dinoMystic,
        description: 'Mystical powers and abilities',
        baseHealth: 4,
        baseSpeed: 1.0,
        baseJumpHeight: 1.3,
        spritePath: 'characters/dino_mystic.png',
        unlockCost: 1000,
        requirement: 'Unlock 5 achievements',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_scout',
        name: 'Scout Dino',
        type: CharacterType.dinoScout,
        description: 'Excellent vision and agility',
        baseHealth: 4,
        baseSpeed: 1.2,
        baseJumpHeight: 1.5,
        spritePath: 'characters/dino_scout.png',
        unlockCost: 1500,
        requirement: 'Score 5000 points',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_warrior',
        name: 'Warrior Dino',
        type: CharacterType.dinoWarrior,
        description: 'Combat specialist',
        baseHealth: 6,
        baseSpeed: 1.1,
        baseJumpHeight: 1.0,
        spritePath: 'characters/dino_warrior.png',
        unlockCost: 2000,
        requirement: 'Defeat 1000 enemies',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_explorer',
        name: 'Explorer Dino',
        type: CharacterType.dinoExplorer,
        description: 'Finds extra coins and treasures',
        baseHealth: 5,
        baseSpeed: 1.0,
        baseJumpHeight: 1.1,
        spritePath: 'characters/dino_explorer.png',
        unlockCost: 2500,
        requirement: 'Collect 100 power-ups',
        isUnlocked: false,
      ),
      
      Character(
        id: 'dino_phoenix',
        name: 'Phoenix Dino',
        type: CharacterType.dinoPhoenix,
        description: 'Can resurrect once per run',
        baseHealth: 5,
        baseSpeed: 1.1,
        baseJumpHeight: 1.2,
        spritePath: 'characters/dino_phoenix.png',
        unlockCost: 5000,
        requirement: 'Reach level 50',
        isUnlocked: false,
      ),
    ];
  }

  /// Get character icon based on type
  IconData getCharacterIcon() {
    switch (type) {
      case CharacterType.dinoClassic:
        return Icons.pets;
      case CharacterType.dinoSpeed:
        return Icons.flash_on;
      case CharacterType.dinoTank:
        return Icons.security;
      case CharacterType.dinoMystic:
        return Icons.auto_awesome;
      case CharacterType.dinoScout:
        return Icons.visibility;
      case CharacterType.dinoWarrior:
        return Icons.gavel;
      case CharacterType.dinoExplorer:
        return Icons.explore;
      case CharacterType.dinoPhoenix:
        return Icons.local_fire_department;
    }
  }

  /// Get character color scheme
  Color getCharacterColor() {
    switch (type) {
      case CharacterType.dinoClassic:
        return Colors.green;
      case CharacterType.dinoSpeed:
        return Colors.blue;
      case CharacterType.dinoTank:
        return Colors.grey;
      case CharacterType.dinoMystic:
        return Colors.purple;
      case CharacterType.dinoScout:
        return Colors.orange;
      case CharacterType.dinoWarrior:
        return Colors.red;
      case CharacterType.dinoExplorer:
        return Colors.amber;
      case CharacterType.dinoPhoenix:
        return Colors.deepOrange;
    }
  }

  /// Get special abilities for this character
  List<String> getSpecialAbilities() {
    switch (type) {
      case CharacterType.dinoClassic:
        return ['Balanced Stats', 'No Weaknesses'];
      case CharacterType.dinoSpeed:
        return ['Speed Boost', 'Quick Recovery', 'Double Jump'];
      case CharacterType.dinoTank:
        return ['Extra Health', 'Damage Resistance', 'Ground Slam'];
      case CharacterType.dinoMystic:
        return ['Magic Shield', 'Teleport', 'Time Slow'];
      case CharacterType.dinoScout:
        return ['Enemy Detection', 'High Jump', 'Safe Landing'];
      case CharacterType.dinoWarrior:
        return ['Combat Bonus', 'Enemy Stun', 'Rage Mode'];
      case CharacterType.dinoExplorer:
        return ['Coin Magnet', 'Treasure Finder', 'Map Reveal'];
      case CharacterType.dinoPhoenix:
        return ['Resurrection', 'Fire Trail', 'Immunity Frames'];
    }
  }

  /// Get ability descriptions
  Map<String, String> getAbilityDescriptions() {
    switch (type) {
      case CharacterType.dinoClassic:
        return {
          'Balanced Stats': 'No strengths or weaknesses',
          'No Weaknesses': 'Well-rounded performance',
        };
      case CharacterType.dinoSpeed:
        return {
          'Speed Boost': '+50% movement speed',
          'Quick Recovery': 'Faster stun recovery',
          'Double Jump': 'Jump again in mid-air',
        };
      case CharacterType.dinoTank:
        return {
          'Extra Health': '+3 additional lives',
          'Damage Resistance': '50% damage reduction',
          'Ground Slam': 'Stun nearby enemies',
        };
      case CharacterType.dinoMystic:
        return {
          'Magic Shield': 'Absorb one hit per run',
          'Teleport': 'Short range teleport',
          'Time Slow': 'Slow down time briefly',
        };
      case CharacterType.dinoScout:
        return {
          'Enemy Detection': 'See enemies through walls',
          'High Jump': '+50% jump height',
          'Safe Landing': 'No fall damage',
        };
      case CharacterType.dinoWarrior:
        return {
          'Combat Bonus': '+2x score from enemies',
          'Enemy Stun': 'Stun enemies on contact',
          'Rage Mode': 'Temporary invincibility',
        };
      case CharacterType.dinoExplorer:
        return {
          'Coin Magnet': 'Attract nearby coins',
          'Treasure Finder': 'Reveal hidden items',
          'Map Reveal': 'Show upcoming obstacles',
        };
      case CharacterType.dinoPhoenix:
        return {
          'Resurrection': 'Revive once per run',
          'Fire Trail': 'Leave damaging trail',
          'Immunity Frames': 'Brief invincibility after hit',
        };
    }
  }

  /// Unlock this character
  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      notifyListeners();
      save();
    }
  }

  /// Add experience to character
  void addExperience(int exp) {
    experience += exp;
    
    // Level up logic (100 exp per level)
    while (experience >= currentLevel * 100 && currentLevel < 10) {
      experience -= currentLevel * 100;
      currentLevel++;
      notifyListeners();
    }
    
    notifyListeners();
    save();
  }

  /// Unlock ability
  void unlockAbility(String abilityName) {
    unlockedAbilities[abilityName] = true;
    notifyListeners();
    save();
  }

  /// Check if ability is unlocked
  bool isAbilityUnlocked(String abilityName) {
    return unlockedAbilities[abilityName] ?? false;
  }

  /// Get current health based on level
  int getCurrentHealth() {
    return baseHealth + (currentLevel - 1);
  }

  /// Get current speed based on level
  double getCurrentSpeed() {
    return baseSpeed + (currentLevel - 1) * 0.05;
  }

  /// Get current jump height based on level
  double getCurrentJumpHeight() {
    return baseJumpHeight + (currentLevel - 1) * 0.03;
  }
}
