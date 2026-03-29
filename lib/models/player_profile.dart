import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_profile.g.dart';

/// Player profile with comprehensive progression system
@HiveType(typeId: 4)
class PlayerProfile extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  String playerName = 'Player';
  
  @HiveField(1)
  int playerLevel = 1;
  
  @HiveField(2)
  int experiencePoints = 0;
  
  @HiveField(3)
  int totalCoins = 0;
  
  @HiveField(4)
  int totalGamesPlayed = 0;
  
  @HiveField(5)
  int totalPlayTime = 0; // in seconds
  
  @HiveField(6)
  int longestRun = 0;
  
  @HiveField(7)
  int totalDistance = 0;
  
  @HiveField(8)
  int totalEnemiesDefeated = 0;
  
  @HiveField(9)
  int totalPowerUpsCollected = 0;
  
  @HiveField(10)
  int perfectRuns = 0; // runs without taking damage
  
  @HiveField(11)
  Map<String, int> themeMastery = {}; // theme -> mastery level
  
  @HiveField(12)
  List<String> unlockedCharacters = []; // character IDs
  
  @HiveField(13)
  String selectedCharacter = 'dino_classic';
  
  @HiveField(14)
  int playerTitle = 0; // title index
  
  @HiveField(15)
  List<String> completedChallenges = [];
  
  @HiveField(16)
  int currentStreak = 0; // daily login streak
  
  @HiveField(17)
  DateTime lastPlayDate = DateTime.now();
  
  @HiveField(18)
  Map<String, bool> skillUnlocks = {}; // skill tree unlocks
  
  // Experience required for next level
  int get experienceToNextLevel {
    return playerLevel * 100; // Simple progression formula
  }
  
  // Experience progress percentage
  double get experienceProgress {
    if (playerLevel >= 100) return 1.0; // Max level
    return experiencePoints / experienceToNextLevel;
  }
  
  // Add experience and handle level ups
  void addExperience(int exp) {
    experiencePoints += exp;
    
    while (experiencePoints >= experienceToNextLevel && playerLevel < 100) {
      experiencePoints -= experienceToNextLevel;
      playerLevel++;
      notifyListeners();
    }
    
    notifyListeners();
    save();
  }
  
  // Add coins
  void addCoins(int coins) {
    totalCoins += coins;
    notifyListeners();
    save();
  }
  
  // Spend coins (returns success)
  bool spendCoins(int amount) {
    if (totalCoins >= amount) {
      totalCoins -= amount;
      notifyListeners();
      save();
      return true;
    }
    return false;
  }
  
  // Update play time
  void updatePlayTime(int additionalSeconds) {
    totalPlayTime += additionalSeconds;
    notifyListeners();
    save();
  }
  
  // Update statistics after a game
  void updateGameStats({
    required int score,
    required int distance,
    required int enemiesDefeated,
    required int powerUpsCollected,
    required bool tookDamage,
    required String themeUsed,
  }) {
    totalGamesPlayed++;
    totalDistance += distance;
    totalEnemiesDefeated += enemiesDefeated;
    totalPowerUpsCollected += powerUpsCollected;
    
    if (distance > longestRun) {
      longestRun = distance;
    }
    
    if (!tookDamage) {
      perfectRuns++;
    }
    
    // Update theme mastery
    themeMastery[themeUsed] = (themeMastery[themeUsed] ?? 0) + 1;
    
    // Add experience based on performance
    int expGained = (score / 10).floor() + 
                   (distance / 100).floor() + 
                   (enemiesDefeated * 5) + 
                   (powerUpsCollected * 3) +
                   (tookDamage ? 0 : 50); // bonus for perfect run
    
    addExperience(expGained);
    
    // Update last play date
    lastPlayDate = DateTime.now();
    
    notifyListeners();
    save();
  }
  
  // Unlock character
  void unlockCharacter(String characterId) {
    if (!unlockedCharacters.contains(characterId)) {
      unlockedCharacters.add(characterId);
      notifyListeners();
      save();
    }
  }
  
  // Select character
  void selectCharacter(String characterId) {
    if (unlockedCharacters.contains(characterId) || characterId == 'dino_classic') {
      selectedCharacter = characterId;
      notifyListeners();
      save();
    }
  }
  
  // Get current title
  String getCurrentTitle() {
    final titles = [
      'Beginner',
      'Runner',
      'Advanced Runner',
      'Expert Runner',
      'Master Runner',
      'Legendary Runner',
      'Mythic Runner',
      'God Runner',
    ];
    
    if (playerTitle < titles.length) {
      return titles[playerTitle];
    }
    return titles.last;
  }
  
  // Update title based on level
  void updateTitle() {
    if (playerLevel >= 80 && playerTitle < 7) {
      playerTitle = 7;
    } else if (playerLevel >= 60 && playerTitle < 6) {
      playerTitle = 6;
    } else if (playerLevel >= 45 && playerTitle < 5) {
      playerTitle = 5;
    } else if (playerLevel >= 30 && playerTitle < 4) {
      playerTitle = 4;
    } else if (playerLevel >= 20 && playerTitle < 3) {
      playerTitle = 3;
    } else if (playerLevel >= 10 && playerTitle < 2) {
      playerTitle = 2;
    } else if (playerLevel >= 5 && playerTitle < 1) {
      playerTitle = 1;
    }
    
    notifyListeners();
    save();
  }
  
  // Complete challenge
  void completeChallenge(String challengeId) {
    if (!completedChallenges.contains(challengeId)) {
      completedChallenges.add(challengeId);
      notifyListeners();
      save();
    }
  }
  
  // Update daily streak
  void updateDailyStreak() {
    final now = DateTime.now();
    final lastDate = lastPlayDate;
    
    if (now.day == lastDate.day && now.month == lastDate.month && now.year == lastDate.year) {
      // Same day, no change
      return;
    }
    
    final difference = now.difference(lastDate).inDays;
    
    if (difference == 1) {
      // Next day, increment streak
      currentStreak++;
    } else if (difference > 1) {
      // More than one day, reset streak
      currentStreak = 1;
    }
    
    lastPlayDate = now;
    notifyListeners();
    save();
  }
  
  // Unlock skill
  void unlockSkill(String skillId) {
    skillUnlocks[skillId] = true;
    notifyListeners();
    save();
  }
  
  // Check if skill is unlocked
  bool isSkillUnlocked(String skillId) {
    return skillUnlocks[skillId] ?? false;
  }
  
  // Get theme mastery level
  int getThemeMastery(String themeId) {
    return themeMastery[themeId] ?? 0;
  }
  
  // Get play time formatted
  String getFormattedPlayTime() {
    final hours = totalPlayTime ~/ 3600;
    final minutes = (totalPlayTime % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  // Get total score across all games
  int getTotalScore() {
    // This would need to be tracked separately or calculated from saved high scores
    return 0; // Placeholder
  }
}
