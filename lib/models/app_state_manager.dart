import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/api/chartlyrics_proxy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lyrics_2/data/sqlite/sqlite_repository.dart';
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
}

class AppStateManager extends ChangeNotifier {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  bool _initialized = false;
  bool _loggedIn = true;
  //bool _onboardingComplete = false;
  int _selectedTab = LyricsTab.search;
  List<LyricSearchResult> _searchResults = List.empty();
  int _status = -1;
  String _errorMessage = "";
  bool _searchCompleted = false;
  bool _isSearching = false;
  Future<Lyric>? _lyric;
  // default search mode
  int _searchType = SearchType.audio;
  String _version = "";
  String _buildNr = "";
  String _favoritesFilter = "";
  //Map<String, String> _settings = Map<String, String>();
  String _searchAudioAuthor = "";
  String _searchAudioSong = "";

  // Accessors
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  //bool get isOnboardingComplete => _onboardingComplete;
  bool get isSearchCompleted => _searchCompleted;
  int get getSelectedTab => _selectedTab;
  List<LyricSearchResult> get searchResults => _searchResults;
  Future<Lyric>? get lyric => _lyric;
  int get lastStatus => _status;
  String get lastErrorMsg => _errorMessage;
  bool get isSearching => _isSearching;
  //bool get isTextSearch => _isTextSearch;
  //bool get isSongAuthorSearch => _isSongAuthorSearch;
  //bool get isAudioSearch => _isAudioSearch;
  //bool get isSongAuthorSearch => !_isTextSearch;
  int get searchType => _searchType;
  String get version => _version;
  String get buildNr => _buildNr;
  String get favoritesFilter => _favoritesFilter;
  void set favoritesFilter(String filter) {
    _favoritesFilter = filter;
  }

  String get searchAudioAuthor => _searchAudioAuthor;
  String get searchAudioSong => _searchAudioSong;
  void set searchAudioAuthor(String author) {
    _searchAudioAuthor = author;
  }

  void set searchAudioSong(String song) {
    _searchAudioSong = song;
  }

  void initializeApp() {
    logger.d("Initialising...");
    Timer(
      const Duration(milliseconds: 2000),
      () {
        _initialized = true;
        //_settings["initialized"] = "true";
        notifyListeners();
      },
    );
  }

  void login(BuildContext context, String username, String password) {
    logger.d("Logging in...");
    final sqlRepository = Provider.of<SQLiteRepository>(context, listen: false);
    //_loggedIn = true;
    //_settings["logged_in"] = "true";
    sqlRepository
        .insertSetting(Setting(setting: Setting.loggedIn, value: "true"));

    notifyListeners();
  }

  Future<void> getVersionInfo() async {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNr = packageInfo.buildNumber;
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
      _status = e.code;
      _errorMessage = e.message;
      _isSearching = false;
    }
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

  void switchSearch(BuildContext context) {
    String msg = "";
    int currSearchType = searchType;
    if (currSearchType == SearchType.text) {
      msg = AppLocalizations.of(context)!.msgSearchSongAuthor;
      _searchType = SearchType.songAuthor;
      //_isTextSearch = false;
      //_isSongAuthorSearch = true;
      //_isAudioSearch = false;
    } else if (currSearchType == SearchType.songAuthor) {
      msg = AppLocalizations.of(context)!.msgSearchAudio;
      _searchType = SearchType.audio;
      //_isTextSearch = false;
      //_isSongAuthorSearch = false;
      //_isAudioSearch = true;
    } else if (currSearchType == SearchType.audio) {
      _searchType = SearchType.text;
      msg = AppLocalizations.of(context)!.msgSearchText;
      //_isTextSearch = true;
      //_isSongAuthorSearch = false;
      //_isAudioSearch = false;
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

  Future<bool> checkOnboarding(BuildContext context) async {
    final sqlRepository = Provider.of<SQLiteRepository>(context, listen: false);
    Setting? onBoardingSavedStatus =
        await sqlRepository.getSetting(Setting.onboardingComplete);
    if (onBoardingSavedStatus == null) return false;
    return onBoardingSavedStatus == "true";
  }

  void completeOnboarding(BuildContext context) {
    //_onboardingComplete = true;
    final sqlRepository = Provider.of<SQLiteRepository>(context, listen: false);
    sqlRepository.insertSetting(
        Setting(setting: Setting.onboardingComplete, value: "true"));
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

  startAudioSearch() {
    final session = ACRCloud.startSession();
  }

  void logout() {
    logger.d("Executing user logout");
    //final sqlRepository = Provider.of<SQLiteRepository>(context, listen: false);
    //_loggedIn = false;
    //_onboardingComplete = false;
    //sqlRepository.insertSetting(
    //    Setting(setting: Setting.onboardingComplete, value: "false"));

    _initialized = false;
    _selectedTab = 0;

    initializeApp();
    notifyListeners();
  }
}
