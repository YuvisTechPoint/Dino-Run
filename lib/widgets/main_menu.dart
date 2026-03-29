import 'dart:ui';

import 'package:flutter/material.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/settings_menu.dart';
import '/widgets/achievements_view.dart';
import '/widgets/theme_selection_menu.dart';
import '/widgets/shop_menu.dart';
import '/widgets/challenges_menu.dart';
import '/widgets/stats_menu.dart';
import '/widgets/character_selection_menu.dart';

// This represents the main menu overlay.
class MainMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'MainMenu';

  // Reference to parent game.
  final DinoRun game;

  const MainMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.black.withAlpha(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 100,
              ),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'Dino Run',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.startGamePlay();
                      game.overlays.remove(MainMenu.id);
                      game.overlays.add(Hud.id);
                    },
                    child: const Text('Play', style: TextStyle(fontSize: 30)),
                  ),
                  _buildMenuButton('Characters', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(CharacterSelectionMenu.id);
                  }),
                  _buildMenuButton('Shop', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(ShopMenu.id);
                  }),
                  _buildMenuButton('Challenges', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(ChallengesMenu.id);
                  }),
                  _buildMenuButton('Themes', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(ThemeSelectionMenu.id);
                  }),
                  _buildMenuButton('Stats', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(StatsMenu.id);
                  }),
                  _buildMenuButton('Achievements', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(AchievementsView.id);
                  }),
                  _buildMenuButton('Settings', () {
                    game.overlays.remove(MainMenu.id);
                    game.overlays.add(SettingsMenu.id);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 30)),
    );
  }
}
