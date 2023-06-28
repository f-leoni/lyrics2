import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:provider/provider.dart';

import 'components/logger.dart';
import 'data/firebase_favorites_repository.dart';
import 'data/firebase_user_repository.dart';
import 'data/sqlite_settings_repository.dart';
import 'lyricstheme.dart';
import 'models/app_state_manager.dart';
import 'navigation/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LyricsApp extends StatefulWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  _LyricsAppState createState() => _LyricsAppState();
}

class _LyricsAppState extends State<LyricsApp> {
  final FirebaseUserRepository _profileManager = FirebaseUserRepository();
  final AppStateManager _appStateManager = AppStateManager();
  late final FirebaseFavoritesRepository _favoritesManager;
  final SQLiteSettingsRepository _settingsManager = SQLiteSettingsRepository();
  late AppRouter _appRouter;

  @override
  void initState() {
    _favoritesManager = FirebaseFavoritesRepository(
        FirebaseFirestore.instance.collection('lyrics'));
    NowPlaying.instance.isEnabled().then((bool isEnabled) async {
      if (!isEnabled) {
        final shown = await NowPlaying.instance.requestPermissions();
        logger.v('MANAGED TO SHOW PERMS PAGE: $shown');
      }
    });
    super.initState();
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      favoritesManager: _favoritesManager,
      profileManager: _profileManager,
      //settingsManager: _settingsManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => _favoritesManager,
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => _settingsManager,
        ),
        StreamProvider<NowPlayingTrack?>.value(
          initialData: NowPlayingTrack.notPlaying,
          value: NowPlaying.instance.stream,
        ),
      ],
      child: Consumer<FirebaseUserRepository>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (_settingsManager.darkMode) {
            theme = LyricsTheme.dark();
          } else {
            theme = LyricsTheme.light();
          }
          return MaterialApp(
            theme: theme,
            title: 'Lyrics2 🎶',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('it', ''), // Italian, no country code
            ],
            debugShowCheckedModeBanner: false,
            home: Router(
              routerDelegate: _appRouter,
              // Add backButtonDispatcher
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        }, // (builder)
      ),
    );
  }
}