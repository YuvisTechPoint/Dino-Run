import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import '../models/game_theme.dart';
import 'theme_manager.dart';

/// Simplified asset preloader for theme assets
class AssetPreloader {
  static final AssetPreloader _instance = AssetPreloader._internal();
  factory AssetPreloader() => _instance;
  AssetPreloader._internal();

  final Map<String, dynamic> _preloadedAssets = {};
  bool _isPreloading = false;
  bool _isPreloaded = false;

  /// Preload all theme assets for instant access
  Future<void> preloadAllAssets(dynamic images) async {
    if (_isPreloaded || _isPreloading) return;
    
    _isPreloading = true;
    
    try {
      final themeManager = ThemeManager();
      final themes = themeManager.themes;
      
      // For now, just mark as preloaded without actual preloading
      // In a real implementation, you would preload actual theme assets
      _preloadedAssets['preloaded'] = true;
      
      _isPreloaded = true;
    } catch (e) {
      print('Error preloading assets: $e');
    } finally {
      _isPreloading = false;
    }
  }

  /// Preload assets for a specific theme
  Future<void> preloadTheme(GameTheme theme, dynamic images) async {
    if (_preloadedAssets.containsKey(theme.name)) {
      return; // Already preloaded
    }
    
    // For now, just mark as preloaded
    _preloadedAssets[theme.name] = true;
  }

  /// Get preloaded asset by path
  dynamic getPreloadedAsset(String path) {
    return _preloadedAssets[path];
  }

  /// Check if asset is preloaded
  bool isAssetPreloaded(String path) {
    return _preloadedAssets.containsKey(path);
  }

  /// Check if image is preloaded (alias for compatibility)
  bool isImagePreloaded(String path) {
    return isAssetPreloaded(path);
  }

  /// Get preloading progress (0.0 to 1.0)
  double getPreloadingProgress() {
    if (_isPreloaded) return 1.0;
    if (_isPreloading) return 0.5;
    return 0.0;
  }

  /// Check if preloading is complete
  bool get isPreloaded => _isPreloaded;

  /// Check if preloading is in progress
  bool get isPreloading => _isPreloading;

  /// Clear preloaded assets (for memory management)
  void clearPreloadedAssets() {
    _preloadedAssets.clear();
    _isPreloaded = false;
    _isPreloading = false;
  }

  /// Get memory usage statistics
  Map<String, int> getMemoryStats() {
    return {
      'preloadedAssets': _preloadedAssets.length,
      'isPreloaded': _isPreloaded ? 1 : 0,
      'isPreloading': _isPreloading ? 1 : 0,
    };
  }
}
