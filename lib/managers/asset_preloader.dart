import 'package:flutter/material.dart';
import 'package:flame/assets.dart';
import '../models/game_theme.dart';
import 'theme_manager.dart';

/// Manages preloading of theme assets for instant access
class AssetPreloader {
  static final AssetPreloader _instance = AssetPreloader._internal();
  factory AssetPreloader() => _instance;
  AssetPreloader._internal();

  final Map<String, Image> _preloadedImages = {};
  final Map<String, List<Image>> _preloadedAnimations = {};
  final Map<String, dynamic> _preloadedAudio = {};
  bool _isPreloading = false;
  bool _isPreloaded = false;

  /// Preload all theme assets for instant access
  Future<void> preloadAllAssets(Images images) async {
    if (_isPreloaded || _isPreloading) return;
    
    _isPreloading = true;
    
    try {
      final themeManager = ThemeManager();
      final themes = themeManager.themes;
      
      // Preload assets for each theme
      for (final theme in themes) {
        await _preloadThemeAssets(theme, images);
      }
      
      _isPreloaded = true;
    } catch (e) {
      print('Error preloading assets: $e');
    } finally {
      _isPreloading = false;
    }
  }

  /// Preload assets for a specific theme
  Future<void> _preloadThemeAssets(GameTheme theme, Images images) async {
    // Preload parallax layers
    for (final layerPath in theme.parallaxLayers) {
      try {
        final image = await images.load(layerPath);
        _preloadedImages[layerPath] = image;
      } catch (e) {
        print('Failed to preload parallax layer $layerPath: $e');
      }
    }

    // Preload ground texture
    try {
      final groundImage = await images.load(theme.groundTexture);
      _preloadedImages[theme.groundTexture] = groundImage;
    } catch (e) {
      print('Failed to preload ground texture ${theme.groundTexture}: $e');
    }

    // Preload enemy sprites
    for (final enemyPath in theme.enemyTypes) {
      try {
        final enemyImage = await images.load(enemyPath);
        _preloadedImages[enemyPath] = enemyImage;
      } catch (e) {
        print('Failed to preload enemy $enemyPath: $e');
      }
    }

    // Preload collectible
    try {
      final collectibleImage = await images.load(theme.collectibleType);
      _preloadedImages[theme.collectibleType] = collectibleImage;
    } catch (e) {
      print('Failed to preload collectible ${theme.collectibleType}: $e');
    }

    // Preload power-up
    try {
      final powerUpImage = await images.load(theme.powerUpType);
      _preloadedImages[theme.powerUpType] = powerUpImage;
    } catch (e) {
      print('Failed to preload power-up ${theme.powerUpType}: $e');
    }

    // Preload particle effect images
    for (final particlePath in theme.particleEffects) {
      try {
        final particleImage = await images.load('particles/$particlePath.png');
        _preloadedImages['particles/$particlePath.png'] = particleImage;
      } catch (e) {
        print('Failed to preload particle $particlePath: $e');
      }
    }

    // Preload special effect images
    for (final effectPath in theme.specialEffects) {
      try {
        final effectImage = await images.load('effects/$effectPath.png');
        _preloadedImages['effects/$effectPath.png'] = effectImage;
      } catch (e) {
        print('Failed to preload effect $effectPath: $e');
      }
    }
  }

  /// Get preloaded image by path
  Image? getPreloadedImage(String path) {
    return _preloadedImages[path];
  }

  /// Check if image is preloaded
  bool isImagePreloaded(String path) {
    return _preloadedImages.containsKey(path);
  }

  /// Get preloading progress (0.0 to 1.0)
  double getPreloadingProgress() {
    if (_isPreloaded) return 1.0;
    if (_isPreloading) return 0.5; // Simplified progress
    return 0.0;
  }

  /// Check if all assets are preloaded
  bool get isPreloaded => _isPreloaded;

  /// Check if currently preloading
  bool get isPreloading => _isPreloading;

  /// Get all preloaded image paths
  List<String> getPreloadedImagePaths() {
    return _preloadedImages.keys.toList();
  }

  /// Clear preloaded assets (for memory management)
  void clearPreloadedAssets() {
    _preloadedImages.clear();
    _preloadedAnimations.clear();
    _preloadedAudio.clear();
    _isPreloaded = false;
    _isPreloading = false;
  }

  /// Preload specific theme on demand
  Future<void> preloadTheme(GameTheme theme, Images images) async {
    if (_preloadedImages.containsKey(theme.groundTexture)) {
      return; // Already preloaded
    }
    
    await _preloadThemeAssets(theme, images);
  }

  /// Get memory usage statistics
  Map<String, int> getMemoryStats() {
    return {
      'images': _preloadedImages.length,
      'animations': _preloadedAnimations.length,
      'audio': _preloadedAudio.length,
    };
  }
}
