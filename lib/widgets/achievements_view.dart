import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';
import '../game/dino_run.dart';
import 'main_menu.dart';

/// Displays all achievements in the game.
class AchievementsView extends StatelessWidget {
  static const String id = 'AchievementsView';
  
  final DinoRun game;

  const AchievementsView(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final achievementManager = AchievementManager();
    
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF4ECDC4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                  Text(
                    '${achievementManager.unlockedCount}/${achievementManager.totalCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Achievements List
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
                    children: achievementManager.achievements.map((achievement) {
                      return _AchievementTile(achievement: achievement);
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Close Button
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove(AchievementsView.id);
                  game.overlays.add(MainMenu.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Back to Menu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: achievement.isUnlocked 
            ? const Color(0xFF4ECDC4).withOpacity(0.2)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: achievement.isUnlocked 
              ? const Color(0xFF4ECDC4)
              : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            achievement.isUnlocked 
                ? Icons.emoji_events
                : Icons.emoji_events_outlined,
            color: achievement.isUnlocked 
                ? Colors.amber
                : Colors.grey,
            size: 30,
          ),
          const SizedBox(width: 15),
          
          // Achievement Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: achievement.isUnlocked 
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: achievement.isUnlocked 
                        ? Colors.white70
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Score: ${achievement.requiredScore}',
                  style: TextStyle(
                    fontSize: 11,
                    color: achievement.isUnlocked 
                        ? const Color(0xFF4ECDC4)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Status
          if (achievement.isUnlocked)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }
}
