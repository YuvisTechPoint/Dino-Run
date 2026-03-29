import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// TODO: Generate Hive adapter with: flutter packages pub run build_runner build
// part 'daily_challenge.g.dart';

/// Enum for different challenge types
enum ChallengeType {
  score,          // Reach X score
  coins,          // Collect X coins
  distance,       // Run X meters
  enemies,        // Dodge X enemies
  combo,          // Achieve X combo
  powerUps,       // Use X power-ups
  noHit,          // Reach X score without getting hit
  specificTheme,  // Play in specific theme
}

/// Represents a daily challenge
@HiveType(typeId: 7)
class DailyChallenge extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final ChallengeType type;
  
  @HiveField(4)
  final int targetValue;
  
  @HiveField(5)
  int _currentProgress;
  
  @HiveField(6)
  final int coinReward;
  
  @HiveField(7)
  final int gemReward;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  bool _isCompleted;
  
  @HiveField(10)
  bool _rewardClaimed;
  
  @HiveField(11)
  final String? themeId; // For theme-specific challenges

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.coinReward,
    this.gemReward = 0,
    this.themeId,
  })  : _currentProgress = 0,
        _isCompleted = false,
        _rewardClaimed = false,
        createdAt = DateTime.now();

  // Getters
  int get currentProgress => _currentProgress;
  bool get isCompleted => _isCompleted;
  bool get rewardClaimed => _rewardClaimed;
  double get progressPercent => (_currentProgress / targetValue).clamp(0.0, 1.0);
  bool get canClaimReward => _isCompleted && !_rewardClaimed;

  /// Update progress
  void updateProgress(int value) {
    if (_isCompleted) return;
    
    _currentProgress = value;
    
    if (_currentProgress >= targetValue) {
      _isCompleted = true;
    }
    
    notifyListeners();
    save();
  }

  /// Add to progress
  void addProgress(int amount) {
    updateProgress(_currentProgress + amount);
  }

  /// Mark reward as claimed
  void claimReward() {
    if (_isCompleted && !_rewardClaimed) {
      _rewardClaimed = true;
      notifyListeners();
      save();
    }
  }

  /// Check if challenge is still valid (not expired)
  bool get isValid {
    final now = DateTime.now();
    final challengeDate = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final today = DateTime(now.year, now.month, now.day);
    return challengeDate == today;
  }

  /// Get difficulty rating
  String get difficulty {
    if (targetValue <= 10) return 'Easy';
    if (targetValue <= 50) return 'Medium';
    if (targetValue <= 100) return 'Hard';
    return 'Expert';
  }

  /// Get difficulty color
  Color get difficultyColor {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      case 'Expert':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Generate random challenge
  static DailyChallenge generateRandom(int seed) {
    final random = Random(seed);
    final types = ChallengeType.values;
    final type = types[random.nextInt(types.length)];
    
    // Generate based on type
    switch (type) {
      case ChallengeType.score:
        return DailyChallenge(
          id: 'score_${DateTime.now().millisecondsSinceEpoch}',
          title: 'High Scorer',
          description: 'Reach ${100 + random.nextInt(900)} points in a single run',
          type: type,
          targetValue: 100 + random.nextInt(900),
          coinReward: 50 + random.nextInt(100),
        );
        
      case ChallengeType.coins:
        return DailyChallenge(
          id: 'coins_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Coin Collector',
          description: 'Collect ${20 + random.nextInt(80)} coins in a single run',
          type: type,
          targetValue: 20 + random.nextInt(80),
          coinReward: 40 + random.nextInt(80),
        );
        
      case ChallengeType.distance:
        return DailyChallenge(
          id: 'distance_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Marathon Runner',
          description: 'Run ${500 + random.nextInt(1500)} meters',
          type: type,
          targetValue: 500 + random.nextInt(1500),
          coinReward: 60 + random.nextInt(120),
        );
        
      case ChallengeType.enemies:
        return DailyChallenge(
          id: 'enemies_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Dodging Master',
          description: 'Dodge ${10 + random.nextInt(40)} enemies',
          type: type,
          targetValue: 10 + random.nextInt(40),
          coinReward: 30 + random.nextInt(60),
        );
        
      case ChallengeType.combo:
        return DailyChallenge(
          id: 'combo_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Combo King',
          description: 'Achieve a combo of ${5 + random.nextInt(20)}',
          type: type,
          targetValue: 5 + random.nextInt(20),
          coinReward: 40 + random.nextInt(80),
          gemReward: random.nextInt(3),
        );
        
      case ChallengeType.powerUps:
        return DailyChallenge(
          id: 'powerups_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Power Player',
          description: 'Collect and use ${3 + random.nextInt(7)} power-ups',
          type: type,
          targetValue: 3 + random.nextInt(7),
          coinReward: 35 + random.nextInt(70),
        );
        
      case ChallengeType.noHit:
        return DailyChallenge(
          id: 'nohit_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Untouchable',
          description: 'Reach ${100 + random.nextInt(400)} points without getting hit',
          type: type,
          targetValue: 100 + random.nextInt(400),
          coinReward: 80 + random.nextInt(160),
          gemReward: 2 + random.nextInt(5),
        );
        
      case ChallengeType.specificTheme:
        final themes = ['classic', 'desert', 'forest', 'city', 'ocean', 'space'];
        final theme = themes[random.nextInt(themes.length)];
        return DailyChallenge(
          id: 'theme_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Theme Explorer',
          description: 'Play in the ${theme.toUpperCase()} theme and score ${50 + random.nextInt(150)} points',
          type: type,
          targetValue: 50 + random.nextInt(150),
          coinReward: 45 + random.nextInt(90),
          themeId: theme,
        );
    }
  }
}
