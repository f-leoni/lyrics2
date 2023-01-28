import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics2/data/sqlite_favorites_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'components/logger.dart';
import 'navigation/app_router.dart';
import 'lyricstheme.dart';
import 'package:catcher/catcher.dart';
import 'package:lyrics2/env.dart';
import 'package:nowplaying/nowplaying.dart';

main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    ConsoleHandler(
      enableStackTrace: true,
      handleWhenRejected: false,
    )
  ]);

  CatcherOptions releaseOptions = CatcherOptions(
    //DialogReportMode(),
    SilentReportMode(),
    [
      SlackHandler(
        Env.slackWebHook,
        "#lyrics2",
        username: "CatcherTest",
        iconEmoji: ":thinking_face:",
        enableDeviceParameters: true,
        enableApplicationParameters: true,
        enableCustomParameters: true,
        enableStackTrace: true,
        printLogs: true,
      ),
    ],
    localizationOptions: [
      LocalizationOptions.buildDefaultItalianOptions(),
    ],
  );

  /*CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["zitzusoft@gmail.com"],
        enableDeviceParameters: true,
        enableStackTrace: true,
        enableCustomParameters: true,
        enableApplicationParameters: true,
        sendHtml: true,
        emailTitle: "Lyrics 2 error report",
        emailHeader: "Lyrics 2 error report",
        printLogs: true)
  ]);*/

  Catcher(
      rootWidget: const LyricsApp(),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);

  NowPlaying.instance.start(resolveImages: true);
}

class LyricsApp extends StatefulWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  _LyricsAppState createState() => _LyricsAppState();
}

class _LyricsAppState extends State<LyricsApp> {
  final _appStateManager = AppStateManager();
  final _favoritesManager = SQLiteFavoritesRepository();
  final _settingsManager = SQLiteSettingsRepository();
  late AppRouter _appRouter;

  @override
  void initState() {
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      favoritesManager: _favoritesManager,
      settingsRepository: _settingsManager,
    );
    NowPlaying.instance.isEnabled().then((bool isEnabled) async {
      if (!isEnabled) {
        final shown = await NowPlaying.instance.requestPermissions();
        logger.v('MANAGED TO SHOW PERMS PAGE: $shown');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _settingsManager,
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
      child: Consumer<SQLiteSettingsRepository>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = LyricsTheme.dark();
          } else {
            theme = LyricsTheme.light();
          }
          return MaterialApp(
            navigatorKey: Catcher.navigatorKey,
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
