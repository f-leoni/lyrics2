import 'package:flutter/material.dart';
import 'package:lyrics_2/models/favorites_manager.dart';
import 'package:provider/provider.dart';
import 'data/memory_repository.dart';
import 'models/models.dart';
import 'navigation/app_router.dart';
import 'lyricstheme.dart';

//final _theme = LyricsTheme.light();

void main() {
  runApp(const LyricsApp());
}

class LyricsApp extends StatefulWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  _LyricsAppState createState() => _LyricsAppState();
}

class _LyricsAppState extends State<LyricsApp> {
  // This widget is the root of your application.
  final _favoritesManager = FavoritesManager();
  final _profileManager = ProfileManager();
  final _appStateManager = AppStateManager();
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      favoritesManager: _favoritesManager,
      profileManager: _profileManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _favoritesManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider<MemoryRepository>(
          lazy: false,
          create: (_) => MemoryRepository(),
        ),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = LyricsTheme.dark();
          } else {
            theme = LyricsTheme.light();
          }
          return MaterialApp(
            theme: theme,
            title: 'Lyrics2 🎶',
            debugShowCheckedModeBanner: false,
            home: Router(
              routerDelegate: _appRouter,
              // Add backButtonDispatcher
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
            // home: const SplashScreen(),
          );
        }, // (builder)
      ),
    );
  }
}