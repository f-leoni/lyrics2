import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/api/chartlyrics_proxy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

class LyricsTab {
  static const int favorites = 0;
  static const int search = 1;
  static const int info = 2;
}

class SearchType {
  static const int text = 0;
  static const int songAuthor = 1;
  static const int audio = 2;
}

class AppStateManager extends ChangeNotifier {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
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
  // search mode - if true search by text else search by author/title
  bool _isTextSearch = true;
  bool _isSongAuthorSearch = false;
  bool _isAudioSearch = false;
  int _searchType = SearchType.text;

  // Accessors
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  bool get isSearchCompleted => _searchCompleted;
  int get getSelectedTab => _selectedTab;
  List<LyricSearchResult> get searchResults => _searchResults;
  Future<Lyric>? get lyric => _lyric;
  int get lastStatus => _status;
  String get lastErrorMsg => _errorMessage;
  bool get isSearching => _isSearching;
  bool get isTextSearch => _isTextSearch;
  bool get isSongAuthorSearch => _isSongAuthorSearch;
  bool get isAudioSearch => _isAudioSearch;
  //bool get isSongAuthorSearch => !_isTextSearch;
  int get searchType => _searchType;

  void initializeApp() {
    logger.d("Initialising...");
    Timer(
      const Duration(milliseconds: 2000),
      () {
        _initialized = true;
        notifyListeners();
      },
    );
  }

  void login(String username, String password) {
    logger.d("Logging in...");
    _loggedIn = true;
    notifyListeners();
  }

  Future<List<LyricSearchResult>> startSearchText(String searchText) async {
    logger.d("Starting Search for [$searchText]...");
    _isSearching = true;
    _searchCompleted = false;
    ChartLyricsProxy clp = ChartLyricsProxy();
    try {
      _searchResults = await clp.simpleSearchText(searchText);
      _status = 200;
      _searchCompleted = true;
      _isSearching = false;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
      //print("Error LyricException code: ${e.code}: ${e.message}");
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    } //*/
    notifyListeners();
    return _searchResults;
  }

  Future<List<LyricSearchResult>> startSearchSongAuthor(
      String author, String song) async {
    logger.d("Starting Search for [$author], [$song]...");
    _isSearching = true;
    _searchCompleted = false;
    ChartLyricsProxy clp = ChartLyricsProxy();
    try {
      _searchResults = await clp.simpleSearch(author, song);
      _status = 200;
      _searchCompleted = true;
      _isSearching = false;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
      //print("Error LyricException code: ${e.code}: ${e.message}");
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    } //*/
    notifyListeners();
    return _searchResults;
  }

  void endSearch() {
    logger.d("Ending search...");
    _isSearching = false;
    _searchCompleted = false;
    notifyListeners();
  }

  void switchSearchOld(BuildContext context) {
    _isTextSearch = !_isTextSearch;
    String msg = "";
    if (_isTextSearch) {
      msg = AppLocalizations.of(context)!.msgSearchText;
    } else {
      msg = AppLocalizations.of(context)!.msgSearchSongAuthor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
    notifyListeners();
  }

  void switchSearch(BuildContext context) {
    String msg = "";
    int currSearchType = searchType;
    int newSearchType;
    if (currSearchType == SearchType.text) {
      msg = AppLocalizations.of(context)!.msgSearchSongAuthor;
      _searchType = SearchType.songAuthor;
      _isTextSearch = false;
      _isSongAuthorSearch = true;
      _isAudioSearch = false;
    } else if (currSearchType == SearchType.songAuthor) {
      msg = AppLocalizations.of(context)!.msgSearchAudio;
      _searchType = SearchType.audio;
      _isTextSearch = false;
      _isSongAuthorSearch = false;
      _isAudioSearch = true;
    } else if (currSearchType == SearchType.audio) {
      _searchType = SearchType.text;
      msg = AppLocalizations.of(context)!.msgSearchText;
      _isTextSearch = true;
      _isSongAuthorSearch = false;
      _isAudioSearch = false;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(milliseconds: 500),
    ));
    notifyListeners();
  }

  Future<Lyric>? getLyric(LyricSearchResult lsr) {
    logger.d("Getting lyrics for song [${lsr.song}]...");
    _status = -1;
    _errorMessage = "";
    try {
      ChartLyricsProxy clp = ChartLyricsProxy();
      _lyric = clp.getLyric(lsr);
      return _lyric;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
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
    logger.d("Executing user logout");
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    initializeApp();
    notifyListeners();
  }
}
