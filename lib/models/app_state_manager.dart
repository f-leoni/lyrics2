import 'dart:async';
import 'package:flutter/material.dart';

// 1
class LyricsTab {
  static const int favorites = 0;
  static const int search = 1;
  static const int info = 2;
}

class AppStateManager extends ChangeNotifier {
  // 2
  bool _initialized = false;
  // 3
  bool _loggedIn = false;
  // 4
  bool _onboardingComplete = false;
  // 5
  int _selectedTab = LyricsTab.search;

  // 6
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

// Add initializeApp (1)
  void initializeApp() {
    // 7
    Timer(
      const Duration(milliseconds: 2000),
      () {
        // 8
        _initialized = true;
        // 9
        notifyListeners();
      },
    );
  }

// Add login (2)
  void login(String username, String password) {
    // 10
    _loggedIn = true;
    // 11
    notifyListeners();
  }

// Add completeOnboarding (3)
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

// Add goToTab (4)
  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

// Add goToRecipes (5)
  void goToRecipes() {
    _selectedTab = LyricsTab.search;
    notifyListeners();
  }

// Add logout (6)
  void logout() {
    // 12
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    // 13
    initializeApp();
    // 14
    notifyListeners();
  }
}
