import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/api/chartlyrics_proxy.dart';
import 'package:lyrics2/api/genius_proxy.dart';
import 'package:lyrics2/components/components_lyrics.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/screens/lyric_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/lyric_tile.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:lyrics2/env.dart';

//TODO implement as a sliverAppBar
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
  ACRCloudResponseMusicItem? music;
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);
  final _searchControllerText = TextEditingController();
  final _searchControllerAuthor = TextEditingController();
  final _searchControllerSong = TextEditingController();
  //final buttonTextStyle = const TextStyle(color: Colors.black87);
  String _searchStringText = "";
  String _searchStringAuthor = "";
  String _searchStringSong = "";
  int minSearchLen = 3;

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
    ACRCloud.setUp(const ACRCloudConfig(
        Env.arApiAccessKey, Env.arApiSecret, Env.arApiHost));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building Search Screen");
    final manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                backgroundColor: users.themeData.backgroundColor,
                expandedHeight: 125.0,
                flexibleSpace: FlexibleSpaceBar(
                  //collapseMode: CollapseMode.pin,

                  background: Column(
                    children: [
                      Expanded(flex: 1, child: buildSearchFields(context)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: buildSearchButton(context),
                        ),
                      ),
                    ],
                  ),
                )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SizedBox(
                  height: 70,
                  child: buildTile(context, index, null),
                );
              },
              childCount: manager.searchResults.length,
            ))
          ])),
    );
  }

  Widget buildSearchFields(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    int searchType = manager.searchType;

    if (searchType == SearchType.text) {
      return buildTextSearchFields(context);
    } else if (searchType == SearchType.songAuthor) {
      return buildSongAuthorSearchFields(context);
    } else {
      // Search by audio recognition
      return buildAudioSearchFields(context);
    }
  }

  Widget buildAudioSearchFields(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    var currLyricsTheme =
        Provider.of<FirebaseUserRepository>(context, listen: false).themeData;
    var currTextTheme =
        Provider.of<FirebaseUserRepository>(context, listen: false).textTheme;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
                alignment: Alignment.centerLeft,
                iconSize: 30,
                onPressed: () {
                  manager.switchSearch(context, _searchControllerText.text,
                      _searchControllerAuthor.text, _searchControllerSong.text);
                },
                icon: const Icon(Icons.refresh_rounded)),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) => ConstrainedBox(
                      constraints:
                          const BoxConstraints(minHeight: 50, maxHeight: 90),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                        //color: Colors.red,
                        child: Center(
                          child: MaterialButton(
                            minWidth: 150,
                            height: 50,
                            color: currLyricsTheme.indicatorColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            onPressed: () async {
                              final provider = Provider.of<AppStateManager>(
                                  context,
                                  listen: false);
                              music = null;
                              provider.searchAudioAuthor = "";
                              provider.searchAudioSong = "";
                              final session = ACRCloud.startSession();
                              logger.d("Showing Audio panel");
                              var dialog = showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: Text(AppLocalizations.of(context)!
                                      .msgListening),
                                  content: StreamBuilder(
                                    stream: session.volumeStream,
                                    initialData: -1,
                                    builder: (_, snapshot) =>
                                        Text(snapshot.data.toString()),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        logger.d("Cancel Listening");
                                        session.cancel;
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .msgCancel),
                                    )
                                  ],
                                ),
                              ).onError((error, stackTrace) =>
                                  logger.e("Dialog Error: $error"));
                              logger.d("Wait for results");
                              final result = await session.result;
                              // Avoid lint error "Do not use BuildContexts across async gaps"
                              if (!mounted) return;
                              logger.d("Hide audio dialog");
                              // Hide dialog
                              Navigator.of(context, rootNavigator: true)
                                  .pop(result);

                              if (result == null) {
                                logger.d("Audio search Canceled");
                                // Search has been cancelled.
                                return;
                              } else if (result.metadata == null) {
                                logger.d(
                                    "Error in Audio Search: ${result.status.msg}");
                                // No results found
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      '${AppLocalizations.of(context)!.noResults}: ${result.status.msg}'),
                                ));
                                return;
                              } else {
                                music = result.metadata!.music.first;
                                if (music != null) {
                                  provider.searchAudioAuthor =
                                      music!.artists.first.name;
                                  provider.searchAudioSong = music!.title;
                                  startSearch(context);
                                }
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.msgListen,
                              style: currTextTheme.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Spread operator to extend a Column widget children collection
                if (music != null ||
                    (manager.searchAudioAuthor != "" &&
                        manager.searchAudioSong != "")) ...[
                  SizedBox.fromSize(size: const Size(1, 9)),
                  Text(
                      '${AppLocalizations.of(context)!.msgTrack}: ${music != null ? music!.title : manager.searchAudioAuthor} - ${music != null ? music!.artists.first.name : manager.searchAudioSong}',
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          //color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          wordSpacing: 5)),
                ],
              ],
            ),
          ),
        ]);
  }

  Widget buildSongAuthorSearchFields(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 30,
            onPressed: () {
              manager.switchSearch(context, _searchControllerText.text,
                  _searchControllerAuthor.text, _searchControllerSong.text);
            },
            icon: const Icon(Icons.refresh_rounded)),
        Flexible(
          flex: 2,
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
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
                      //hintStyle: const TextStyle(fontSize: 8),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context)
                          .backgroundColor, //Colors.yellow[50],
                    ),
                    //onEditingComplete: () => startSearch(context),
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(5)),
                Expanded(
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
                      //hintStyle: const TextStyle(fontSize: 8),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context)
                          .backgroundColor, //Colors.yellow[50],
                    ),
                    //onEditingComplete: () => startSearch(context),
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

  Widget buildTextSearchFields(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    //_searchControllerText.text = _searchStringText;
    return Row(
      //mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            //color: Colors.red,
            iconSize: 25,
            onPressed: () {
              manager.switchSearch(context, _searchControllerText.text,
                  _searchControllerAuthor.text, _searchControllerSong.text);
            },
            icon: const Icon(Icons.refresh_rounded)),
        Expanded(
          flex: 1,
          child: TextField(
            controller: _searchControllerText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
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
              fillColor: Theme.of(context).backgroundColor, //Colors.yellow[50],
            ),
            onEditingComplete: () => startSearch(context),
          ),
        ),
      ],
    );
  }

  Widget buildSearchButton(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    bool isDarkMode =
        Provider.of<FirebaseUserRepository>(context, listen: false).darkMode;
    var currLyricsTheme =
        Provider.of<FirebaseUserRepository>(context, listen: false).themeData;
    var currTextTheme =
        Provider.of<FirebaseUserRepository>(context, listen: false).textTheme;
    int searchType = manager.searchType;
    if (searchType == SearchType.audio) {
      return const SizedBox(
        height: 1,
      );
    } else {
      return MaterialButton(
        minWidth: 150,
        height: 50,
        color: currLyricsTheme.indicatorColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          AppLocalizations.of(context)!.searchText,
          style: currTextTheme.button,
        ),
        onPressed: () async {
          logger.v("Click on Search button in search screen");
          startSearch(context);
        },
      );
    }
  }

  Future<void> startSearch(BuildContext context) async {
    final manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
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
        content: Text(AppLocalizations.of(context)!.searchTextTooShort),
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

  @override
  void dispose() {
    logger.d("Disposing of Search Screen");
    _searchControllerText.dispose();
    _searchControllerAuthor.dispose();
    _searchControllerSong.dispose();
    super.dispose();
  }

  void showNoResultsMsg(List<LyricSearchResult> results) {
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.noResults),
      ));
    }
  }

  // List of found Lyrics
  Widget buildList(BuildContext context) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    logger.d("Building results list");
    double height = MediaQuery.of(context).size.height / 2 - 31; //, 236;
    if (manager.isSearchCompleted) {
      List<LyricSearchResult> results = manager.searchResults;
      List<Widget> itemTiles = List<Widget>.empty(growable: true);
      for (LyricSearchResult lyricSearchResult in results) {
        // Exclude invalid results
        if (!lyricSearchResult.isEmpty && lyricSearchResult.lyricId != 0) {
          itemTiles.add(buildTile(context, 0, lyricSearchResult));
        }
      }
      return SizedBox(
          height: height,
          //color: Colors.green,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: itemTiles,
          ));
    } else {
      // Case for isSearchComplete == false
      return SizedBox(
          height: height,
          //color: Colors.green,
          child: ListView(
              padding: const EdgeInsets.all(10.0), children: const []));
    }
  }

  Widget buildTile(
      BuildContext context, int? index, LyricSearchResult? lyricSearchResult) {
    final manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    if (manager.isSearchCompleted) {
      List<LyricSearchResult> results = manager.searchResults;
      LyricSearchResult lsr;
      if (lyricSearchResult == null) {
        lsr = results[index!];
      } else {
        lsr = lyricSearchResult;
      }
      int hIndex = index! + 1;
      return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 2.0, color: users.themeData.highlightColor),
        )),
        child: InkWell(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    hIndex.toString(),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.8,
                  ),
                ),
              ),
              LyricTile(
                lyric: lsr,
                isFavoritePage: false,
              ),
            ],
          ),
          onTap: () {
            logger.i("Clicked on Search result. Song: ${lsr.song}");
            /*Provider.of<AppStateManager>(context, listen: false).viewedLyric =
                    provider.getLyric(lyricSearchResult)!;
                Provider.of<AppStateManager>(context, listen: false)
                    .isViewingLyric = true;*/
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LyricDetailScreen(
                  lyric: manager.getLyric(lsr,
                      users.useGenius ? GeniusProxy() : ChartLyricsProxy()),
                ),
              ),
            );
          },
        ),
      );
    }
    return Container();
  }
}
