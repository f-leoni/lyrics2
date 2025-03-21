import 'package:flutter/material.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/screens/screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/circle_image.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final FirebaseFavoritesRepository favoritesManager;
  final FirebaseUserRepository profileManager;
  BuildContext? _context;

  AppRouter({
    required this.appStateManager,
    required this.favoritesManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    favoritesManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building AppRouter");
    _context = context;
    final repository = Provider.of<SQLiteSettingsRepository>(context);
    final profile = Provider.of<FirebaseUserRepository>(context);
    Future<Map<String, Setting>> fSettings = repository.getSettings();

    return FutureBuilder(
      future: fSettings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, Setting> settings =
                snapshot.data as Map<String, Setting>;
            bool isOnboardingComplete =
                settings[Setting.onboardingComplete]?.value == "true";
            bool isLoggedIn = profile.isLoggedIn();
            return Navigator(
              key: navigatorKey,
              onPopPage: _handlePopPage,
              //onDidRemovePage: _handlePopPage
              pages: [
                if (!appStateManager.isInitialized) SplashScreen.page(),
                if (appStateManager.isInitialized && !isLoggedIn)
                  LoginScreen.page(),
                if (isLoggedIn && !isOnboardingComplete)
                  OnboardingScreen.page(),
                if (isOnboardingComplete)
                  MainScreen.page(appStateManager.getSelectedTab),
                if (profileManager.didSelectUser)
                  ProfileScreen.page(profileManager.getUser!),
                if (appStateManager.isViewingLyric)
                  ShowLyricScreen.page(
                    Future.value(appStateManager.viewedLyric),
                  ),
              ], // pages[]
            );
          } else {
            //return buildSpinner(); //;Text("No data found in settings")
            return buildSpinnerAlt(
              context,
            ); //;Text("No data found in settings")
          }
        } else {
          return buildSpinnerAlt(context); //Text("Getting settings from DB")
        }
      },
    );
  }

  Widget buildSpinner() {
    //return Container();
    return Container(
      color: profileManager.themeData.colorScheme.surface,
      child: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: profileManager.themeData.primaryColor,
          ),
        ),
      ),
    );
  }

  // Return a fake scaffold to try and avoid "blink" of the screen
  Widget buildSpinnerAlt(BuildContext pContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: profileManager.themeData.colorScheme.primaryContainer,
        title: Text(AppLocalizations.of(pContext)!.appName),
        titleTextStyle: profileManager.textTheme.displayLarge,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: CircleImage(
                imageProvider:
                    Provider.of<FirebaseUserRepository>(
                      pContext,
                      listen: false,
                    ).userImage,
              ),
            ),
          ),
        ],
      ),
      // Select which tab is to be shown
      body: Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: profileManager.themeData.primaryColor,
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '...'),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page), label: '...'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '...'),
        ],
      ),
    );
  }

  // What to do when a page is closed or dismissed ("popped")?
  bool _handlePopPage(
    //  argument 1 - current route
    Route<dynamic> route,
    // argument 2 - value that returns when the route completes
    result,
  ) {
    if (!route.didPop(result)) {
      return false;
    }
    // Handle Onboarding and splash
    if (route.settings.name == LyricsPages.onboardingPath) {
      appStateManager.logout(_context!);
    }
    // Handle state when user closes profile screen
    if (route.settings.name == LyricsPages.profilePath) {
      profileManager.tapOnProfile(false);
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
  Future<void> setNewRoutePath(configuration) async => {
    logger.d("setNewRoutePath called!"),
  };

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    favoritesManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }
}
