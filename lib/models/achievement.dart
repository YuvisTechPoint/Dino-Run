import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'achievement.g.dart';

/// Represents an achievement in the game.
@HiveType(typeId: 1)
class Achievement extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final int requiredScore;
  
  @HiveField(4)
  bool _isUnlocked = false;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredScore,
  });

  bool get isUnlocked => _isUnlocked;

  set isUnlocked(bool value) {
    if (_isUnlocked != value) {
      _isUnlocked = value;
      notifyListeners();
      save();
    }
  }

  /// Check if this achievement should be unlocked based on the current score.
  void checkUnlock(int currentScore) {
    if (!_isUnlocked && currentScore >= requiredScore) {
      isUnlocked = true;
    }
  }
}

/// Manages all achievements in the game.
class AchievementManager extends ChangeNotifier {
  final List<Achievement> _achievements = [];

  List<Achievement> get achievements => List.unmodifiable(_achievements);

  AchievementManager() {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    _achievements.addAll([
      Achievement(
        id: 'first_steps',
        title: 'First Steps',
        description: 'Score your first 10 points',
        requiredScore: 10,
      ),
      Achievement(
        id: 'runner',
        title: 'Runner',
        description: 'Score 100 points',
        requiredScore: 100,
      ),
      Achievement(
        id: 'advanced_runner',
        title: 'Advanced Runner',
        description: 'Score 500 points',
        requiredScore: 500,
      ),
      Achievement(
        id: 'expert_runner',
        title: 'Expert Runner',
        description: 'Score 1000 points',
        requiredScore: 1000,
      ),
      Achievement(
        id: 'master_runner',
        title: 'Master Runner',
        description: 'Score 2500 points',
        requiredScore: 2500,
      ),
      Achievement(
        id: 'legendary_runner',
        title: 'Legendary Runner',
        description: 'Score 5000 points',
        requiredScore: 5000,
      ),
    ]);
  }

  /// Check all achievements against the current score.
  void checkAchievements(int currentScore) {
    for (var achievement in _achievements) {
      achievement.checkUnlock(currentScore);
    }
    notifyListeners();
  }

  /// Get the number of unlocked achievements.
  int get unlockedCount {
    return _achievements.where((a) => a.isUnlocked).length;
  }

  /// Get the total number of achievements.
  int get totalCount => _achievements.length;

  /// Get achievement by ID.
  Achievement? getAchievementById(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
