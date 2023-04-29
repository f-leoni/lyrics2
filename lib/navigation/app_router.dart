import 'package:flutter/material.dart';
import 'package:lyrics2/components/logger.dart';
//import 'package:lyrics2/data/sqlite_favorites_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  //final SQLiteFavoritesRepository favoritesManager;
  final SQLiteSettingsRepository settingsRepository;
  BuildContext? _context;

  AppRouter({
    required this.appStateManager,
    // required this.favoritesManager,
    required this.settingsRepository,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    //favoritesManager.addListener(notifyListeners);
    //settingsRepository.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building AppRouter");
    _context = context;
    final settingsRepository = Provider.of<SQLiteSettingsRepository>(context);
    //Future<Map<String, Setting>> fSettings = settingsRepository.getSettings();
    Future<bool> fOnboarding =
        appStateManager.checkOnboarding(settingsRepository);

    return FutureBuilder(
      future: fOnboarding, //fSettings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            /*Map<String, Setting> settings =
                snapshot.data as Map<String, Setting>;
            bool isOnboardingComplete =
                settings[Setting.onboardingComplete]?.value == "true";*/
            bool isOnboardingComplete = snapshot.data as bool;
            return Navigator(
              key: navigatorKey,
              onPopPage: _handlePopPage,
              pages: [
                if (!appStateManager.isInitialized) SplashScreen.page(),
                /*if (appStateManager.isInitialized && !isLoggedIn)
                  LoginScreen.page(),*/
                if (appStateManager.isInitialized & !isOnboardingComplete)
                  OnboardingScreen.page(),
                if (isOnboardingComplete)
                  MainScreen.page(appStateManager.getSelectedTab),
                if (settingsRepository.didSelectUser) ProfileScreen.page(),
                if (appStateManager.isViewingLyric)
                  ShowLyricScreen.page(
                      Future.value(appStateManager.viewedLyric)),
              ], // pages[]
            );
          } else {
            return buildSpinner(); //;Text("No data found in settings")
          }
        } else {
          return buildSpinner(); //Text("Getting settings from DB")
        }
      },
    );
  }

  Widget buildSpinner() {
    //return Container();
    return Container(
        color: settingsRepository.themeData.backgroundColor,
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: settingsRepository.themeData.primaryColor,
            ),
          ),
        ));
  }

  // What do do when a page is closed or dismissed ("popped")?
  bool _handlePopPage(
      //  argument 1 - current route
      Route<dynamic> route,
      // argument 2 - value that returns when the route completes
      result) {
    if (!route.didPop(result)) {
      return false;
    }
    // Handle Onboarding and splash
    if (route.settings.name == LyricsPages.onboardingPath) {
      appStateManager.logout(_context!);
    }
    // Handle state when user closes profile screen
    if (route.settings.name == LyricsPages.profilePath) {
      settingsRepository.tapOnProfile(false);
    }
    // Handle state when user closes Lyrics View Screen
    if (route.settings.name == LyricsPages.showLyricPath) {
      appStateManager.isViewingLyric = false;
      appStateManager.viewedLyric = Lyric.empty;
      appStateManager.goToTab(appStateManager.getSelectedTab);
    }
    if (route.settings.name == LyricsPages.infoPath) {
      appStateManager.goToTab(LyricsTab.search);
    }
    // Handle state when user closes WebView screen
    /*if (route.settings.name == LyricsPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }*/
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async =>
      {logger.d("setNewRoutePath called!")};

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    //favoritesManager.removeListener(notifyListeners);
    //settingsRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
