import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/character.dart';
import '../models/player_profile.dart';

/// Manages character selection and progression
class CharacterManager extends ChangeNotifier {
  List<Character> _characters = [];
  Character? _selectedCharacter;
  final Map<String, int> _characterExperience = {};

  List<Character> get characters => List.unmodifiable(_characters);
  Character? get selectedCharacter => _selectedCharacter;

  CharacterManager() {
    _initializeCharacters();
  }

  void _initializeCharacters() {
    _characters = Character.getPredefinedCharacters();
    _selectedCharacter = _characters.first; // Default to classic dino
    
    // Initialize experience tracking
    for (final character in _characters) {
      _characterExperience[character.id] = 0;
    }
  }

  /// Select a character
  void selectCharacter(Character character) {
    if (character.isUnlocked) {
      _selectedCharacter = character;
      notifyListeners();
    }
  }

  /// Unlock character
  void unlockCharacter(Character character) {
    character.unlock();
    notifyListeners();
  }

  /// Add experience to selected character
  void addCharacterExperience(int exp) {
    if (_selectedCharacter != null) {
      _characterExperience[_selectedCharacter!.id] = 
          (_characterExperience[_selectedCharacter!.id] ?? 0) + exp;
      _selectedCharacter!.addExperience(exp);
      notifyListeners();
    }
  }

  /// Get character by ID
  Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get unlocked characters
  List<Character> getUnlockedCharacters() {
    return _characters.where((c) => c.isUnlocked).toList();
  }

  /// Get character experience
  int getCharacterExperience(String characterId) {
    return _characterExperience[characterId] ?? 0;
  }
}
