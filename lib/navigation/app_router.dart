import 'package:flutter/material.dart';
import 'package:lyrics_2/models/favorites_manager.dart';

import '../models/models.dart';
import '../screens/screens.dart';

// 1
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // 2
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  // 3
  final AppStateManager appStateManager;
  // 4
  final FavoritesManager favoritesManager;
  // 5
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.favoritesManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    // Add Listeners (11)
    appStateManager.addListener(notifyListeners);
    favoritesManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  // 6
  @override
  Widget build(BuildContext context) {
    // 7
    return Navigator(
      // 8
      key: navigatorKey,
      // Add onPopPage (10)
      onPopPage: _handlePopPage,
      // 9
      pages: [
        // Add SplashScreen (16)
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          MainScreen.page(appStateManager.getSelectedTab),
        //Home.page(appStateManager.getSelectedTab),
        // Create new item
        /*if (favoritesManager.isCreatingNewItem)
          GroceryItemScreen.page(
            onCreate: (item) {
              favoritesManager.addItem(item);
            },
            onUpdate: (item, index) {
            },
          ),*/
        // Select GroceryItemScreen
        /*if (favoritesManager.selectedIndex != -1)
          GroceryItemScreen.page(
              item: favoritesManager.selectedGroceryItem,
              index: favoritesManager.selectedIndex,
              onUpdate: (item, index) {
                favoritesManager.updateItem(item, index);
              },
              onCreate: (_) {
                // 4 No create
              }),*/
        // Add Profile Screen
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        // Add WebView Screen
        //if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
      ], // pages[]
    );
  }

  // Dispose listeners (12)
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    favoritesManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // Add _handlePopPage (9)
  // What do do when a page is closed or dismissed ("popped")?
  bool _handlePopPage(
      //  argument 1 - current route
      Route<dynamic> route,
      // argument 2 - value that returns when the route completes
      result) {
    // 3
    if (!route.didPop(result)) {
      // 4
      return false;
    }
    // 5
    // Handle Onboarding and splash
    if (route.settings.name == LyricsPages.onboardingPath) {
      appStateManager.logout();
    }
    // Handle state when user closes grocery item screen
    /*if (route.settings.name == LyricsPages.groceryItemDetails) {
      favoritesManager.groceryItemTapped(-1);
    }*/
    // Handle state when user closes profile screen
    if (route.settings.name == LyricsPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    // Handle state when user closes WebView screen
    if (route.settings.name == LyricsPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    // 6
    return true;
  }

  // 10
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
