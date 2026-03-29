import 'package:flutter/material.dart';
import '../models/game_theme.dart';
import '../managers/asset_preloader.dart';
import '../game/effects_manager.dart';

/// Widget for previewing theme features and effects
class ThemePreview extends StatefulWidget {
  final GameTheme theme;
  final VoidCallback onSelect;
  final bool isSelected;

  const ThemePreview({
    super.key,
    required this.theme,
    required this.onSelect,
    this.isSelected = false,
  });

  @override
  State<ThemePreview> createState() => _ThemePreviewState();
}

class _ThemePreviewState extends State<ThemePreview> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.theme.primaryColor.withOpacity(0.8),
                widget.theme.secondaryColor.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.theme.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: widget.isSelected 
                  ? Colors.white.withOpacity(0.8)
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onSelect,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Header
                    Row(
                      children: [
                        // Theme Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _getThemeIcon(widget.theme.type),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Theme Title and Description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.theme.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.theme.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Selection Indicator
                        if (widget.isSelected)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Theme Features Grid
                    _buildFeaturesGrid(),
                    
                    const SizedBox(height: 20),
                    
                    // Weather and Effects
                    _buildWeatherEffectsRow(),
                    
                    const SizedBox(height: 16),
                    
                    // Asset Status
                    _buildAssetStatusRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎮 Game Features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFeatureChip(
                  'Enemies',
                  widget.theme.enemyTypes.length.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFeatureChip(
                  'Collectibles',
                  '1 Type',
                  Icons.star,
                  Colors.yellow,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFeatureChip(
                  'Power-ups',
                  '1 Type',
                  Icons.bolt,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherEffectsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildWeatherEffectCard(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSpecialEffectsCard(),
        ),
      ],
    );
  }

  Widget _buildWeatherEffectCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getWeatherIcon(widget.theme.weatherEffect),
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Weather',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatWeatherEffect(widget.theme.weatherEffect),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialEffectsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.purple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Effects',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.theme.specialEffects.length} Special Effects',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetStatusRow() {
    final assetPreloader = AssetPreloader();
    final isPreloaded = assetPreloader.isImagePreloaded(widget.theme.groundTexture);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPreloaded 
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isPreloaded ? Icons.cloud_done : Icons.cloud_download,
            color: isPreloaded ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isPreloaded ? 'Assets Preloaded' : 'Assets Ready',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const Spacer(),
          Text(
            'Instant Access',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(GameThemeType type) {
    switch (type) {
      case GameThemeType.classic:
        return Icons.pets;
      case GameThemeType.desert:
        return Icons.wb_sunny;
      case GameThemeType.forest:
        return Icons.park;
      case GameThemeType.city:
        return Icons.location_city;
      case GameThemeType.ocean:
        return Icons.water;
      case GameThemeType.space:
        return Icons.star;
      case GameThemeType.candy:
        return Icons.cake;
      case GameThemeType.winter:
        return Icons.ac_unit;
      case GameThemeType.jungle:
        return Icons.nature;
      case GameThemeType.volcano:
        return Icons.local_fire_department;
    }
  }

  IconData _getWeatherIcon(String weatherEffect) {
    switch (weatherEffect) {
      case 'snow':
        return Icons.ac_unit;
      case 'rain':
        return Icons.grain;
      case 'sandstorm':
        return Icons.air;
      case 'ash_storm':
        return Icons.cloud;
      case 'candy_rain':
        return Icons.cake;
      case 'meteor_shower':
        return Icons.nights_stay;
      case 'underwater_current':
        return Icons.waves;
      case 'humidity':
        return Icons.water_drop;
      case 'gentle_breeze':
        return Icons.air;
      default:
        return Icons.wb_sunny;
    }
  }

  String _formatWeatherEffect(String weatherEffect) {
    return weatherEffect
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Enhanced theme selection menu with preview cards
class EnhancedThemeSelectionMenu extends StatefulWidget {
  static const String id = 'EnhancedThemeSelectionMenu';
  
  final List<GameTheme> themes;
  final Function(GameTheme) onThemeSelected;
  final GameTheme? currentTheme;

  const EnhancedThemeSelectionMenu({
    super.key,
    required this.themes,
    required this.onThemeSelected,
    this.currentTheme,
  });

  @override
  State<EnhancedThemeSelectionMenu> createState() => _EnhancedThemeSelectionMenuState();
}

class _EnhancedThemeSelectionMenuState extends State<EnhancedThemeSelectionMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose Your Theme',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.themes.length} Themes Available • All Unlocked',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Theme List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: widget.themes.length,
                itemBuilder: (context, index) {
                  final theme = widget.themes[index];
                  return ThemePreview(
                    theme: theme,
                    isSelected: widget.currentTheme == theme,
                    onSelect: () {
                      widget.onThemeSelected(theme);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
