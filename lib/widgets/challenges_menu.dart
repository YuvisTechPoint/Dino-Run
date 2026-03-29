import 'package:flutter/material.dart';
import '../game/dino_run.dart';
import '../managers/challenge_manager.dart';
import '../models/daily_challenge.dart';

/// Menu for viewing and claiming daily challenges
class ChallengesMenu extends StatefulWidget {
  static const String id = 'ChallengesMenu';
  final DinoRun game;

  const ChallengesMenu(this.game, {super.key});

  @override
  State<ChallengesMenu> createState() => _ChallengesMenuState();
}

class _ChallengesMenuState extends State<ChallengesMenu> {
  late ChallengeManager _challengeManager;

  @override
  void initState() {
    super.initState();
    _challengeManager = ChallengeManager(widget.game.playerData as dynamic);
    _challengeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildChallengesList(),
            ),
            _buildStreakDisplay(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.game.overlays.remove(ChallengesMenu.id);
                  widget.game.overlays.add('MainMenu');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Back', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final completed = _challengeManager.completedCount;
    final total = _challengeManager.totalCount;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade800, Colors.orange.shade900],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'DAILY CHALLENGES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard('Completed', '$completed/$total', Colors.green),
              const SizedBox(width: 16),
              _buildStatCard(
                'Rewards',
                _challengeManager.canClaimRewards ? 'Ready!' : 'None',
                _challengeManager.canClaimRewards ? Colors.amber : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesList() {
    final challenges = _challengeManager.challenges;
    
    if (challenges.isEmpty) {
      return const Center(
        child: Text(
          'No challenges available',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return _buildChallengeCard(challenge);
      },
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge) {
    final canClaim = challenge.canClaimReward;
    final isCompleted = challenge.isCompleted;
    
    Color cardColor;
    if (canClaim) {
      cardColor = Colors.green.withOpacity(0.3);
    } else if (isCompleted) {
      cardColor = Colors.grey.withOpacity(0.2);
    } else {
      cardColor = Colors.blue.withOpacity(0.2);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: canClaim
              ? Colors.green
              : (isCompleted ? Colors.grey : Colors.blue),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: challenge.difficultyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: challenge.difficultyColor),
                  ),
                  child: Text(
                    challenge.difficulty,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: challenge.difficultyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: challenge.progressPercent,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : Colors.blue,
                ),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${challenge.currentProgress}/${challenge.targetValue}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                
                // Reward display
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge.coinReward}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                      ),
                    ),
                    if (challenge.gemReward > 0) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.diamond, color: Colors.purple, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge.gemReward}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            
            if (canClaim) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _claimReward(challenge.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Claim Reward'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStreakDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                '${_challengeManager.streak} Day Streak',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Complete all daily challenges to continue!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _claimReward(String challengeId) {
    final success = _challengeManager.claimReward(challengeId);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reward claimed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
