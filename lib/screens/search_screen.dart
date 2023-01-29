import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/api/chartlyrics_proxy.dart';
import 'package:lyrics2/api/genius_proxy.dart';
import 'package:lyrics2/api/proxies.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/components/lyric_tile.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/components/search_selector.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';

import '../api/proxy.dart';
import '../components/now_playing_panel.dart';

class SearchScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.searchResultsPath,
      key: ValueKey(LyricsPages.searchResultsPath),
      child: const SearchScreen(),
    );
  }

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchControllerText = TextEditingController();
  final _searchControllerAuthor = TextEditingController();
  final _searchControllerSong = TextEditingController();
  String _searchStringText = "";
  String _searchStringAuthor = "";
  String _searchStringSong = "";
  int minSearchLen = 3;
  Widget spinner = Container();

  @override
  void initState() {
    final manager = Provider.of<AppStateManager>(context, listen: false);
    _searchControllerText.text = manager.lastTextSearch;
    _searchControllerAuthor.text = manager.lastAuthorSearch;
    _searchControllerSong.text = manager.lastSongSearch;
    _searchStringText = _searchControllerText.text;
    _searchStringAuthor = _searchControllerAuthor.text;
    _searchStringSong = _searchControllerSong.text;
    _searchControllerText.addListener(() {
      _searchStringText = _searchControllerText.text;
    });
    _searchControllerAuthor.addListener(() {
      _searchStringAuthor = _searchControllerAuthor.text;
    });
    _searchControllerSong.addListener(() {
      _searchStringSong = _searchControllerSong.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building Search Screen");
    final manager = Provider.of<AppStateManager>(context, listen: false);
    int searchType = manager.searchType;
    var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
      return Scaffold(
        backgroundColor: users.themeData.primaryColor,
        body: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(0.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                  SliverAppBar(
                      pinned: false,
                      snap: true,
                      floating: true,
                      backgroundColor: users.themeData.primaryColor,
                      expandedHeight: 100.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: buildSearchFields(context),
                        ),
                            Expanded(
                              flex:1,
                              child: buildSearchSelector(
                                  searchType,
                                  _searchControllerText,
                                  _searchControllerAuthor,
                                  _searchControllerSong),
                            ),
                          ],
                        ),
                      ),
                        ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return buildTile(context, index);
                    },
                    childCount: manager.searchResults.length,
                  ))
                ])),
            spinner
          ],
        ),
      );
  }

  Widget buildSearchFields(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    int searchType = manager.searchType;

    switch(searchType){
      case SearchType.nowPlaying:
        {
          var currProxy = users.useGenius ? GeniusProxy() : ChartLyricsProxy();
          return buildNowPlayingSearchFields(context, currProxy);
        }
      case SearchType.songAuthor:
        {
          return buildSongAuthorSearchFields(context);
        }
      case SearchType.text:
      default:
        {
          return buildTextSearchFields(context);
        }
    }
  }

  Widget buildSongAuthorSearchFields(BuildContext context) {
    //var manager = Provider.of<AppStateManager>(context, listen: false);
    //var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*IconButton(
            iconSize: 50,
            onPressed: () {
              manager.switchSearch(context, _searchControllerText.text,
                  _searchControllerAuthor.text, _searchControllerSong.text);
            },
            icon: Icon(
              Icons.radio_outlined,
              color: users.themeData.colorScheme.secondary,
            )),*/
        Flexible(
          flex: 2,
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    child: TextField(
                      //textAlignVertical: TextAlignVertical.bottom,
                      controller: _searchControllerAuthor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Clear the search field
                            _searchControllerAuthor.text = "";
                          },
                        ),
                        hintText: AppLocalizations.of(context)!.searchAuthorHint,
                        border: const UnderlineInputBorder(),
                        filled: false,
                        fillColor: Theme.of(context)
                            .backgroundColor, //Colors.yellow[50],
                      ),
                      //onEditingComplete: () => startSearch(context),
                    ),
                  ),
                ),
                //SizedBox.fromSize(size: const Size.fromHeight(5)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: _searchControllerSong,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Clear the search field
                            _searchControllerSong.text = "";
                          },
                        ),
                        hintText: AppLocalizations.of(context)!.searchSongHint,
                        border: const UnderlineInputBorder(),
                        filled: false,
                        fillColor: Theme.of(context)
                            .backgroundColor, //Colors.yellow[50],
                      ),
                      //onEditingComplete: () => startSearch(context),
                    ),
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNowPlayingSearchFields(BuildContext context, Proxy proxy) {
    return NowPlayingPanel(proxy: proxy);
  }

  Widget buildTextSearchFields(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
            child: TextField(
              controller: _searchControllerText,
              onSubmitted: (value) => startSearch(context),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => startSearch(context)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear the search field
                    _searchControllerText.text = "";
                  },
                ),
                hintText: AppLocalizations.of(context)!.searchHint,
                border: const UnderlineInputBorder(), //OutlineInputBorder(),
                filled: false,
                fillColor:
                    Theme.of(context).backgroundColor, //Colors.yellow[50],
              ),
              onEditingComplete: () => startSearch(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSearchButton(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    var theme =
        Provider.of<SQLiteSettingsRepository>(context, listen: false).themeData;
    var textTheme =
        Provider.of<SQLiteSettingsRepository>(context, listen: false).textTheme;
    int searchType = manager.searchType;
    if (searchType == SearchType.audio) {
      return const SizedBox(
        height: 1,
      );
    } else {
      return MaterialButton(
        minWidth: 150,
        height: 50,
        color: theme.indicatorColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          AppLocalizations.of(context)!.searchText,
          style: textTheme.button,
        ),
        onPressed: () async {
          logger.v("Click on Search button in search screen");
          startSearch(context);
        },
      );
    }
  }

  Widget buildTile(BuildContext context, int index) {
    final manager = Provider.of<AppStateManager>(context, listen: false);
    final theme =
        Provider.of<SQLiteSettingsRepository>(context, listen: false).themeData;
    if (manager.isSearchCompleted) {
      List<LyricSearchResult> results = manager.searchResults;
      LyricSearchResult lsr = results[index];
      //int hIndex = index + 1;
      return InkWell(
        child: LyricTile(
          lyric: lsr,
          isFavoritePage: false,
        ),
        onTap: () async {
          logger.d("Clicked on Search result tile. Song: ${lsr.song}");
          setState(() {
            spinner = Center(
                child: SizedBox(
                    height: 115,
                    width: 115,
                    child: Container(
                      color: Colors.white12,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: theme.indicatorColor,
                          backgroundColor: theme.primaryColor,
                          strokeWidth: 8,
                        ),
                      ),
                    )));
          });
          var lyric = await manager.getLyric(
              lsr,
              lsr.provider == Proxies.genius
                  ? GeniusProxy()
                  : ChartLyricsProxy())!;
          manager.viewLyric(lyric);
        },
      );
    }
    return Container();
  }

  Future<void> startSearch(BuildContext context) async {
    final manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    var theme = users.themeData;
    var currProxy = users.useGenius ? GeniusProxy() : ChartLyricsProxy();
    manager.lastTextSearch = _searchControllerText.text;
    manager.lastAuthorSearch = _searchControllerAuthor.text;
    manager.lastSongSearch = _searchControllerSong.text;
    var searchType = manager.searchType;

    if (searchType == SearchType.text &&
            _searchStringText.length < minSearchLen ||
        searchType == SearchType.songAuthor &&
            (_searchStringSong.length < minSearchLen ||
                _searchStringAuthor.length < minSearchLen)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.searchTextTooShort,
          style: theme.textTheme.button,
        ),
      ));
      return;
    }
    //Hide virtual keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchType == SearchType.text) {
      await manager.startSearchText(_searchStringText, currProxy);
    } else if (searchType == SearchType.songAuthor) {
      await manager.startSearchSongAuthor(
          _searchStringAuthor, _searchStringSong, currProxy);
    } else if (searchType == SearchType.audio) {
      await manager.startSearchSongAuthor(
          manager.searchAudioAuthor, manager.searchAudioSong, currProxy);
    }
    showNoResultsMsg(manager.searchResults);
  }

  void showNoResultsMsg(List<LyricSearchResult> results) {
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.noResults,
            style: Provider.of<SQLiteSettingsRepository>(context, listen: false)
                .textTheme
                .button),
      ));
    }
  }

  SearchSelector buildSearchSelector(
      int searchType,
      TextEditingController searchControllerText,
      TextEditingController searchControllerAuthor,
      TextEditingController searchControllerSong,
      ) {
    return SearchSelector(
        searchType: searchType,
        searchControllerText: _searchControllerText,
        searchControllerAuthor: _searchControllerAuthor,
        searchControllerSong: _searchControllerSong);
  }

  @override
  void dispose() {
    logger.d("Disposing of Search Screen");
    _searchControllerText.dispose();
    _searchControllerAuthor.dispose();
    _searchControllerSong.dispose();
    super.dispose();
  }
}
