import 'package:flutter/material.dart';
import 'package:lyrics_2/data/sqlite/sqlite_repository.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/models/profile_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics_2/screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  //final FavoritesManager favoritesManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    //required this.favoritesManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    //favoritesManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<SQLiteRepository>(context);
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
            return Navigator(
              key: navigatorKey,
              onPopPage: _handlePopPage,
              pages: [
                if (!appStateManager.isInitialized) SplashScreen.page(),
                if (appStateManager.isInitialized &&
                    !appStateManager.isLoggedIn)
                  LoginScreen.page(),
                if (appStateManager.isLoggedIn && !isOnboardingComplete)
                  OnboardingScreen.page(),
                if (isOnboardingComplete)
                  MainScreen.page(appStateManager.getSelectedTab),
                if (profileManager.didSelectUser)
                  ProfileScreen.page(profileManager.getUser),
                if (appStateManager.isViewingLyric)
                  LyricDetailScreen.page(
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

  Container buildSpinner() {
    return Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.amber,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    //favoritesManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
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
      appStateManager.logout();
    }
    // Handle state when user closes profile screen
    if (route.settings.name == LyricsPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    // Handle state when user closes WebView screen
    if (route.settings.name == LyricsPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => {};
}
