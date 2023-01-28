import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lyrics2/api/proxy.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:provider/provider.dart';

class LyricsTab {
  static const int favorites = 0;
  static const int search = 1;
  static const int info = 2;
}

class SearchType {
  static const int text = 0;
  static const int songAuthor = 1;
  static const int audio = 2;
  static const int nowPlaying = 3;
}

class AppStateManager extends ChangeNotifier {
  //Private
  bool _initialized = false;
  bool _loggedIn = false;
  int _selectedTab = LyricsTab.search;
  List<LyricSearchResult> _searchResults = List.empty();
  int _status = -1;
  String _errorMessage = "";
  bool _searchCompleted = false;
  bool _isSearching = false;
  Future<Lyric>? _lyric;
  // default search mode
  int _searchType = SearchType.text;
  String _version = "";
  String _buildNr = "";
  final bool _showSnackBar = false;
  final icnFavorite = Icons.favorite;
  final icnNoFavorite = Icons.favorite_border;

  //Public
  String favoritesFilter = "";
  String searchAudioAuthor = "";
  String searchAudioSong = "";
  bool isViewingLyric = false;
  Lyric viewedLyric = Lyric.empty;
  String lastTextSearch = "";
  String lastAuthorSearch = "";
  String lastSongSearch = "";

  // Accessors
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isSearchCompleted => _searchCompleted;
  int get getSelectedTab => _selectedTab;
  List<LyricSearchResult> get searchResults => _searchResults;
  Future<Lyric>? get lyric => _lyric;
  int get lastStatus => _status;
  String get lastErrorMsg => _errorMessage;
  bool get isSearching => _isSearching;
  int get searchType => _searchType;
  String get version => _version;
  String get buildNr => _buildNr;

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

  void login(BuildContext context, String username, String password) {
    logger.d("Logging in...");
    _loggedIn = true;
    notifyListeners();
  }

  Future<List<String>> getVersionInfo() async {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNr = packageInfo.buildNumber;
    return Future.value([packageInfo.version, packageInfo.buildNumber]);
  }

  Future<String> startSearchText(String searchText, Proxy lyricsService) async {
    logger.d("Starting Search for [$searchText]...");
    _isSearching = true;
    _searchCompleted = false;
    try {
      _searchResults = await lyricsService.simpleSearchText(searchText);
      _status = 200;
      _searchCompleted = true;
      _isSearching = false;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    } on Exception catch (e) {
      logger.e("An generic exception occurred: ${e.toString()}...");
      _status = 500;
      _errorMessage = e.toString();
      _isSearching = false;
    }
    notifyListeners();
    //return _searchResults;
    return searchText;
  }

  Future<List<String>> startSearchSongAuthor(
      String author, String song, Proxy lyricsService) async {
    logger.d("Starting Search for [$author], [$song]...");
    _isSearching = true;
    _searchCompleted = false;
    try {
      _searchResults = await lyricsService.simpleSearch(author, song);
      _status = 200;
      _searchCompleted = true;
      _isSearching = false;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    }
    notifyListeners();
    //return _searchResults;
    return [author, song];
  }

  void endSearch() {
    logger.d("Ending search...");
    _isSearching = false;
    _searchCompleted = false;
    notifyListeners();
  }

  void switchSearch(BuildContext context, int newSearchType,
      String textSearch, String authorSearch, String songSearch) {
    String msg = "";
    //int currSearchType = searchType;
    _searchType = newSearchType;
    /*
    // TEXT -> AUDIO
    if (currSearchType == SearchType.text) {
      // Save Textfield text
      msg = switchText2Audio(context, textSearch);
      // AUDIO -> TEXT
    } else if (currSearchType == SearchType.audio) {
      msg = switchAudio2Text(context);
    }*/
    if (_showSnackBar) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg,
            style: Provider.of<SQLiteSettingsRepository>(context, listen: false)
                .textTheme
                .button),
        duration: const Duration(milliseconds: 500),
      ));
    }
    notifyListeners();
  }

  String switchAudio2Text(BuildContext context) {
    _searchType = SearchType.text;
    return AppLocalizations.of(context)!.msgSearchText;
  }

  String switchText2Audio(BuildContext context, String textSearch) {
    lastTextSearch = textSearch;
    _searchType = SearchType.audio;
    return AppLocalizations.of(context)!.msgSearchAudio;
  }

  int nextSearchType(int currSearchType) {
    if (currSearchType == SearchType.text) return SearchType.songAuthor;
    if (currSearchType == SearchType.songAuthor) return SearchType.audio;
    // if (currSearchType == SearchType.audio)
    return SearchType.text;
  }

  Future<Lyric>? getLyric(LyricSearchResult lsr, Proxy lyricsService) {
    logger.d("Getting lyrics for song [${lsr.song}]...");
    _status = -1;
    _errorMessage = "";
    try {
      //Proxy lyricsService = _currService;
      _lyric = lyricsService.getLyric(lsr);
      return _lyric;
    } on LyricException catch (e) {
      logger.e("An exception occurred: ${e.message} (${e.code})...");
      _status = e.code;
      _errorMessage = e.message;
      return Lyric.empty;
    }
  }

  Future<bool> checkOnboarding(BuildContext context) async {
    final sqlRepository =
        Provider.of<SQLiteSettingsRepository>(context, listen: false);
    Setting? onBoardingSavedStatus =
        await sqlRepository.getSetting(Setting.onboardingComplete);
    if (onBoardingSavedStatus == null) return false;
    return onBoardingSavedStatus.value == "true";
  }

  Future<void> completeOnboarding(BuildContext context) async {
    final sqlRepository =
        Provider.of<SQLiteSettingsRepository>(context, listen: false);
    await sqlRepository.insertSetting(
        Setting(setting: Setting.onboardingComplete, value: "true"));

    //TODO Smells like a bad hack... remove if possible
    // Waiting 500ms to allow sqlite writing data before reading again
    Timer(
      const Duration(milliseconds: 500),
          () {
        notifyListeners();
      },
    );
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  /*void goToLyrics() {
    _selectedTab = LyricsTab.search;
    notifyListeners();
  }*/

  void logout(BuildContext context) {
    logger.d("Executing user logout");
    final favoritesRepository =
        Provider.of<SQLiteSettingsRepository>(context, listen: false);
    _searchResults = List.empty();
    _searchType = SearchType.text;
    isViewingLyric = false;
    lastTextSearch = "";
    lastAuthorSearch = "";
    _selectedTab = LyricsTab.search;
    _loggedIn = false;
    favoritesRepository.insertSetting(
        Setting(setting: Setting.onboardingComplete, value: "false"));

    _initialized = false;

    initializeApp();
    notifyListeners();
  }

  void viewLyric(Lyric lyric) {
    viewedLyric = lyric;
    isViewingLyric = true;
    notifyListeners();
  }
}
