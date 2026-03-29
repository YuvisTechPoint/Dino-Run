import 'package:flutter/material.dart';
import '../game/dino_run.dart';
import '../models/player_stats.dart';

/// Statistics dashboard for viewing gameplay analytics
class StatsMenu extends StatefulWidget {
  static const String id = 'StatsMenu';
  final DinoRun game;

  const StatsMenu(this.game, {super.key});

  @override
  State<StatsMenu> createState() => _StatsMenuState();
}

class _StatsMenuState extends State<StatsMenu> with SingleTickerProviderStateMixin {
  late PlayerStats _stats;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _stats = PlayerStats(); // Will be loaded from game
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                Tab(icon: Icon(Icons.play_arrow), text: 'Gameplay'),
                Tab(icon: Icon(Icons.collections), text: 'Collection'),
                Tab(icon: Icon(Icons.emoji_events), text: 'Records'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.blue,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildGameplayTab(),
                  _buildCollectionTab(),
                  _buildRecordsTab(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.game.overlays.remove(StatsMenu.id);
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade800, Colors.blue.shade900],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'STATISTICS',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your progress and achievements',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatCard(
            'Total Runs',
            '${_stats.totalRuns}',
            Icons.play_circle,
            Colors.green,
          ),
          _buildStatCard(
            'Playtime',
            _stats.formattedPlaytime,
            Icons.access_time,
            Colors.blue,
          ),
          _buildStatCard(
            'Total Distance',
            _stats.formattedDistance,
            Icons.straighten,
            Colors.orange,
          ),
          _buildStatCard(
            'Highest Score',
            '${_stats.highestScore}',
            Icons.emoji_events,
            Colors.amber,
          ),
          _buildStatCard(
            'Days Playing',
            '${_stats.daysSinceFirstPlay}',
            Icons.calendar_today,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildGameplayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionTitle('Combat Stats'),
          _buildStatCard(
            'Enemies Dodged',
            '${_stats.enemiesDodged}',
            Icons.directions_run,
            Colors.green,
          ),
          _buildStatCard(
            'Hits Taken',
            '${_stats.hitsTaken}',
            Icons.favorite_border,
            Colors.red,
          ),
          _buildStatCard(
            'Dodge Accuracy',
            '${_stats.dodgeAccuracy.toStringAsFixed(1)}%',
            Icons.shield,
            Colors.blue,
          ),
          _buildStatCard(
            'Highest Combo',
            '${_stats.highestCombo}',
            Icons.whatshot,
            Colors.orange,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Run Stats'),
          _buildStatCard(
            'Average Score',
            '${_stats.averageScore.toStringAsFixed(0)}',
            Icons.show_chart,
            Colors.purple,
          ),
          _buildStatCard(
            'Longest Run',
            '${_stats.longestRun}s',
            Icons.timer,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionTitle('Coins'),
          _buildStatCard(
            'Total Coins',
            '${_stats.totalCoinsCollected}',
            Icons.monetization_on,
            Colors.amber,
          ),
          ..._stats.coinsByType.entries.map((entry) => 
            _buildStatCard(
              '${entry.key} Coins',
              '${entry.value}',
              Icons.circle,
              _getCoinColor(entry.key),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Power-ups'),
          _buildStatCard(
            'Power-ups Collected',
            '${_stats.powerUpsCollected}',
            Icons.bolt,
            Colors.yellow,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionTitle('Personal Bests'),
          _buildStatCard(
            'All-Time High Score',
            '${_stats.highestScore}',
            Icons.military_tech,
            Colors.amber,
          ),
          _buildStatCard(
            'Longest Run Time',
            '${_stats.longestRun}s',
            Icons.schedule,
            Colors.blue,
          ),
          _buildStatCard(
            'Best Combo',
            '${_stats.highestCombo}',
            Icons.local_fire_department,
            Colors.orange,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Favorites'),
          if (_stats.favoriteTheme != null)
            _buildStatCard(
              'Favorite Theme',
              _stats.favoriteTheme!,
              Icons.palette,
              Colors.purple,
            ),
          if (_stats.favoriteCharacter != null)
            _buildStatCard(
              'Favorite Character',
              _stats.favoriteCharacter!,
              Icons.person,
              Colors.teal,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCoinColor(String coinType) {
    switch (coinType.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      default:
        return Colors.grey;
    }
  }
}
