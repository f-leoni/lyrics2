import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:nowplaying/nowplaying_track.dart';
import 'package:provider/provider.dart';
import 'components/logger.dart';
import 'navigation/app_router.dart';
import 'lyricstheme.dart';
import 'firebase_options.dart';

main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  ).then((value) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by
    // the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    NowPlaying.instance.start(resolveImages: true);
    runApp(const LyricsApp());
  }); // Firebase Initialization
}

class LyricsApp extends StatefulWidget {
  const LyricsApp({super.key});

  @override
  State<LyricsApp> createState() => _LyricsAppState();
}

class _LyricsAppState extends State<LyricsApp> {
  final _profileManager = FirebaseUserRepository();
  final _appStateManager = AppStateManager();
  late final FirebaseFavoritesRepository _favoritesManager;
  final _settingsManager = SQLiteSettingsRepository();
  late AppRouter _appRouter;

  @override
  void initState() {
    _favoritesManager = FirebaseFavoritesRepository(
        FirebaseFirestore.instance.collection('lyrics'));
    NowPlaying.instance.isEnabled().then((bool isEnabled) async {
      if (!isEnabled) {
        final shown = await NowPlaying.instance.requestPermissions();
        logger.t('MANAGED TO SHOW PERMS PAGE: $shown');
      }
    });
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
        ),
        StreamProvider<NowPlayingTrack?>.value(
          initialData: NowPlayingTrack.notPlaying,
          value: NowPlaying.instance.stream,
        ),
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
            title: 'Lyrics2 ?',
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
