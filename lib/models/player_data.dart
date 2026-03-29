import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    final previousScore = _currentScore;
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    // Check for new achievements
    if (value > previousScore) {
      _checkScoreAchievements(value);
    }

    notifyListeners();
    save();
  }
  
  // Combo tracking
  int _comboCount = 0;
  
  int get comboCount => _comboCount;
  
  void incrementCombo() {
    _comboCount++;
    notifyListeners();
  }
  
  void resetCombo() {
    _comboCount = 0;
    notifyListeners();
  }
  
  // Check for score-based achievements
  void _checkScoreAchievements(int score) {
    // This will be handled by AchievementManager
    // Keeping the method here for potential future use
  }
}
