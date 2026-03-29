import 'package:flame/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/hud.dart';
import 'game/dino_run.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'models/achievement.dart';
import 'models/game_theme.dart';
import 'models/wallet.dart';
import 'models/shop_item.dart';
import 'models/daily_challenge.dart';
import 'models/character.dart';
import 'models/player_stats.dart';
import 'widgets/pause_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';
import 'widgets/achievements_view.dart';
import 'widgets/theme_selection_menu.dart';
import 'widgets/shop_menu.dart';
import 'widgets/challenges_menu.dart';
import 'widgets/stats_menu.dart';
import 'widgets/character_selection_menu.dart';

Future<void> main() async {
  // Ensures that all bindings are initialized
  // before was start calling hive and flame code
  // dealing with platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes hive and register the adapters.
  await initHive();
  runApp(const DinoRunApp());
}

// This function will initilize hive with apps documents directory.
// Additionally it will also register all the hive adapters.
Future<void> initHive() async {
  // For web hive does not need to be initialized.
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
  Hive.registerAdapter<Settings>(SettingsAdapter());
  Hive.registerAdapter<Achievement>(AchievementAdapter());
  Hive.registerAdapter<GameTheme>(GameThemeAdapter());
  Hive.registerAdapter<Wallet>(WalletAdapter());
  Hive.registerAdapter<ShopItem>(ShopItemAdapter());
  Hive.registerAdapter<DailyChallenge>(DailyChallengeAdapter());
  Hive.registerAdapter<Character>(CharacterAdapter());
  Hive.registerAdapter<PlayerStats>(PlayerStatsAdapter());
}

// The main widget for this game.
class DinoRunApp extends StatelessWidget {
  const DinoRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget<DinoRun>.controlled(
          // This will dislpay a loading bar until [DinoRun] completes
          // its onLoad method.
          loadingBuilder: (conetxt) => const Center(
            child: SizedBox(width: 200, child: LinearProgressIndicator()),
          ),
          // Register all the overlays that will be used by this game.
          overlayBuilderMap: {
            MainMenu.id: (_, game) => MainMenu(game),
            PauseMenu.id: (_, game) => PauseMenu(game),
            Hud.id: (_, game) => Hud(game),
            GameOverMenu.id: (_, game) => GameOverMenu(game),
            SettingsMenu.id: (_, game) => SettingsMenu(game),
            AchievementsView.id: (_, game) => AchievementsView(game),
            ThemeSelectionMenu.id: (_, game) => ThemeSelectionMenu(game),
            ShopMenu.id: (_, game) => ShopMenu(game),
            ChallengesMenu.id: (_, game) => ChallengesMenu(game),
            StatsMenu.id: (_, game) => StatsMenu(game),
            CharacterSelectionMenu.id: (_, game) => CharacterSelectionMenu(game),
          },
          // By default MainMenu overlay will be active.
          initialActiveOverlays: const [MainMenu.id],
          gameFactory: () => DinoRun(
            // Use a fixed resolution camera to avoid manually
            // scaling and handling different screen sizes.
            camera: CameraComponent.withFixedResolution(
              width: 360,
              height: 180,
            ),
          ),
        ),
      ),
    );
  }
}
