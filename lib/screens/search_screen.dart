import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics_2/components/components_lyrics.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/components/lyric_tile.dart';
import 'package:logger/logger.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:lyrics_2/env.dart';

class SearchScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.loginPath,
      key: ValueKey(LyricsPages.loginPath),
      child: const SearchScreen(),
    );
  }

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  ACRCloudResponseMusicItem? music;
  final Color rwColor = Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle =
      const TextStyle(color: Color.fromRGBO(64, 143, 77, 1));
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);
  final _searchControllerText = TextEditingController();
  final _searchControllerAuthor = TextEditingController();
  final _searchControllerSong = TextEditingController();
  String _searchStringText = "";
  String _searchStringAuthor = "";
  String _searchStringSong = "";
  int minSearchLen = 3;

  @override
  void initState() {
    _searchControllerText.addListener(() {
      setState(() {
        _searchStringText = _searchControllerText.text;
      });
    });
    _searchControllerAuthor.addListener(() {
      setState(() {
        _searchStringAuthor = _searchControllerAuthor.text;
      });
    });
    _searchControllerSong.addListener(() {
      setState(() {
        _searchStringSong = _searchControllerSong.text;
      });
    });

    ACRCloud.setUp(ACRCloudConfig(arApiAccessKey, arApiSecret, arApiHost));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            /*decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5)),*/
            child: Center(
                child: Column(children: [
              Expanded(
                flex: 3,
                child: Consumer<AppStateManager>(
                    builder: (context, appStateManager, child) {
                  return buildSearchFields(context);
                }),
              ),
              Expanded(
                  flex: 1,
                  child: Consumer<AppStateManager>(
                      builder: (context, appStateManager, child) {
                    return buildButton(context);
                  })),
              Expanded(
                flex: 8,
                child: Consumer<AppStateManager>(
                    builder: (context, appStateManager, child) {
                  return buildList(context);
                }),
              )
            ])),
          )),
    );
  }

  Widget buildSearchFields(BuildContext context) {
    int searchType =
        Provider.of<AppStateManager>(context, listen: false).searchType;

    if (searchType == SearchType.text) {
      return Row(
        //mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              //color: Colors.red,
              iconSize: 25,
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .switchSearch(context);
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
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow[50],
              ),
              onEditingComplete: () => startSearch(context),
            ),
          ),
        ],
      );
    } else if (searchType == SearchType.songAuthor) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              iconSize: 30,
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .switchSearch(context);
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
                        hintText:
                            AppLocalizations.of(context)!.searchAuthorHint,
                        //hintStyle: const TextStyle(fontSize: 8),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.yellow[50],
                      ),
                      onEditingComplete: () => startSearch(context),
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
                        fillColor: Colors.yellow[50],
                      ),
                      onEditingComplete: () => startSearch(context),
                    ),
                  ),
                  SizedBox.fromSize(size: const Size.fromHeight(5)),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Search bu audio recognition
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
                    Provider.of<AppStateManager>(context, listen: false)
                        .switchSearch(context);
                  },
                  icon: const Icon(Icons.refresh_rounded)),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Builder(
                    builder: (context) => ConstrainedBox(
                      constraints:
                          const BoxConstraints(minHeight: 30, maxHeight: 50),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 30, 0),
                        //color: Colors.red,
                        child: MaterialButton(
                          color: rwColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.msgListen,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: startListening,
                        ),
                      ),
                    ),
                  ),
                  // Spread operator to extend a Column widget children collection
                  if (music != null ||
                      (Provider.of<AppStateManager>(context, listen: false)
                                  .searchAudioAuthor !=
                              "" &&
                          Provider.of<AppStateManager>(context, listen: false)
                                  .searchAudioSong !=
                              "")) ...[
                    SizedBox.fromSize(size: Size(1, 9)),
                    Text(
                        AppLocalizations.of(context)!.msgTrack +
                            ': ${music != null ? music!.title : Provider.of<AppStateManager>(context, listen: false).searchAudioAuthor} - ${music != null ? music!.artists.first.name : Provider.of<AppStateManager>(context, listen: false).searchAudioSong}',
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: Colors.black)),
                  ],
                ],
              ),
            ),
          ]);
    }
  }

  Future<void> startListening() async {
    final provider = Provider.of<AppStateManager>(context, listen: false);
    setState(() {
      music = null;
      provider.searchAudioAuthor = "";
      provider.searchAudioSong = "";
    });
    final session = ACRCloud.startSession();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.msgListening),
        content: StreamBuilder(
          stream: session.volumeStream,
          initialData: 0,
          builder: (_, snapshot) => Text(snapshot.data.toString()),
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.msgCancel),
            onPressed: session.cancel,
          )
        ],
      ),
    );

    final result = await session.result;
    // Hide dialog
    Navigator.of(context, rootNavigator: true).pop(result);

    if (result == null) {
      // Search has been cancelled.
      return;
    } else if (result.metadata == null) {
      // No results found
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context)!.noResults + ': ${result.status.msg}'),
      ));
      return;
    } else {
      setState(() {
        music = result.metadata!.music.first;
        if (music != null) {
          provider.searchAudioAuthor = music!.artists.first.name;
          provider.searchAudioSong = music!.title;
          startSearch(context);
        }
      });
    }
  }

  Widget buildButton(BuildContext context) {
    /*bool isAudioSearch =
        Provider.of<AppStateManager>(context, listen: false).isAudioSearch;*/
    int searchType =
        Provider.of<AppStateManager>(context, listen: false).searchType;
    if (searchType == SearchType.audio) {
      return Container();
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 30, maxHeight: 50),
        child: MaterialButton(
          color: rwColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            AppLocalizations.of(context)!.searchText,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            logger.v("Click on Search button in search screen");
            startSearch(context);
          },
        ),
      );
    }
  }

  // List of found Lyrics
  Widget buildList(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 2 - 31; //, 236;
    if (Provider.of<AppStateManager>(context, listen: false)
        .isSearchCompleted) {
      List<LyricSearchResult> results =
          Provider.of<AppStateManager>(context, listen: false).searchResults;
      List<Widget> itemTiles = List<Widget>.empty(growable: true);
      for (LyricSearchResult lyricSearchResult in results) {
        var provider = Provider.of<AppStateManager>(context, listen: false);
        // Exclude invalid results
        if (!lyricSearchResult.isEmpty && lyricSearchResult.lyricId != 0) {
          itemTiles.add(InkWell(
            child: LyricTile(
              lyric: lyricSearchResult,
            ),
            onTap: () {
              logger.i(
                  "Clicked on Search result. Song: ${lyricSearchResult.song}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LyricDetailScreen(
                    lyric: provider.getLyric(lyricSearchResult),
                  ),
                ),
              );
            },
          ));
        }
      }
      return SizedBox(
          height: _height,
          //color: Colors.green,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: itemTiles,
          ));
    } else {
      // Case for isSearchComplete == false
      return SizedBox(
          height: _height,
          //color: Colors.green,
          child: ListView(
              padding: const EdgeInsets.all(10.0), children: const []));
    }
  }

  void startSearch(BuildContext context) {
    int searchType =
        Provider.of<AppStateManager>(context, listen: false).searchType;
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

    var provider = Provider.of<AppStateManager>(context, listen: false);
    //Hide virtual keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchType == SearchType.text) {
      provider.startSearchText(_searchStringText);
    } else if (searchType == SearchType.songAuthor) {
      provider.startSearchSongAuthor(_searchStringAuthor, _searchStringSong);
    } else if (searchType == SearchType.audio) {
      provider.startSearchSongAuthor(
          provider.searchAudioAuthor, provider.searchAudioSong);
    }
    showNoResultsMsg(
        Provider.of<AppStateManager>(context, listen: false).searchResults);
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
}
