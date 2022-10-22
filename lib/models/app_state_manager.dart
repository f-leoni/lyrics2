import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/api/chartlyrics_proxy.dart';

class LyricsTab {
  static const int favorites = 0;
  static const int search = 1;
  static const int info = 2;
}

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedIn = true;
  bool _onboardingComplete = false;
  int _selectedTab = LyricsTab.search;
  List<LyricSearchResult> _searchResults = List.empty();
  int _status = -1;
  String _errorMessage = "";
  bool _searchCompleted = false;
  bool _isSearching = false;
  Future<Lyric>? _lyric;

  // Accessors
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  bool get isSearchCompleted => _searchCompleted;
  int get getSelectedTab => _selectedTab;
  List<LyricSearchResult> get searchResults => _searchResults;
  Future<Lyric>? get lyric => _lyric;

  void initializeApp() {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        _initialized = true;
        notifyListeners();
      },
    );
  }

  void login(String username, String password) {
    _loggedIn = true;
    notifyListeners();
  }

  Future<List<LyricSearchResult>> startSearch(String searchText) async {
    _isSearching = true;
    _searchCompleted = false;
    chartLyricsProxy clp = chartLyricsProxy();
    try {
      _searchResults = await clp.simpleSearchText(searchText);
      _status = 200;
      _searchCompleted = true;
      _isSearching = false;
    } on LyricException catch (e) {
      //print("Error LyricException code: ${e.code}: ${e.message}");
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    } //*/
    notifyListeners();
    return _searchResults;
  }

  void endSearch() {
    _isSearching = false;
    _searchCompleted = false;
    notifyListeners();
  }

  Future<Lyric>? getLyric(LyricSearchResult lsr) {
    _status = -1;
    _errorMessage = "";
    try {
      chartLyricsProxy clp = chartLyricsProxy();
      _lyric = clp.getLyric(lsr);
      return _lyric;
    } on LyricException catch (e) {
      _status = e.code;
      _errorMessage = e.message;
      return _lyric;
    }
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToLyrics() {
    _selectedTab = LyricsTab.search;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    initializeApp();
    notifyListeners();
  }
}
