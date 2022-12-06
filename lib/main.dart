import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'navigation/app_router.dart';
import 'lyricstheme.dart';
import 'package:firebase_core/firebase_core.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    runApp(const LyricsApp());
  }); // Firebase Initialization
}

class LyricsApp extends StatefulWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  _LyricsAppState createState() => _LyricsAppState();
}

class _LyricsAppState extends State<LyricsApp> {
  // This widget is the root of your application.
  //final _favoritesManager = FavoritesManager();
  final _profileManager = FirebaseUserRepository(); //ProfileManager();
  final _appStateManager = AppStateManager();
  final _favoritesManager = FirebaseFavoritesRepository();
  final _settingsManager = SQLiteSettingsRepository();
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
        )
      ],
      child: Consumer<FirebaseUserRepository>(
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
            // home: const SplashScreen(),
          );
        }, // (builder)
      ),
    );
  }
}
