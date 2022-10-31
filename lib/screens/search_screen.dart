import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics_2/components/components_lyrics.dart';
import 'package:provider/provider.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/components/lyric_tile.dart';
import 'package:logger/logger.dart';

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
  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);
  final _searchControllerText = TextEditingController();
  final _searchControllerAuthor = TextEditingController();
  final _searchControllerSong = TextEditingController();
  String _searchStringText = "";
  String _searchStringAuthor = "";
  String _searchStringSong = "";
  var logger = Logger(
    printer: PrettyPrinter(),
  );

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            /*decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5)),*/
            child: Center(
                child: Column(children: [
              Consumer<AppStateManager>(
                  builder: (context, appStateManager, child) {
                return buildSearchFields(context);
              }),
              buildButton(context),
              Consumer<AppStateManager>(
                  builder: (context, appStateManager, child) {
                return buildList(context);
              })
            ])),
          )),
    );
  }

  Widget buildSearchFields(BuildContext context) {
    bool isTextSearch =
        Provider.of<AppStateManager>(context, listen: false).isTextSearch;
    if (isTextSearch) {
      return SizedBox(
        //color: Colors.green,
        height: 96,
        width: double.infinity,
        child: Row(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                //color: Colors.red,
                iconSize: 25,
                onPressed: () {
                  Provider.of<AppStateManager>(context, listen: false)
                      .switchSearch();
                },
                icon: Icon(Icons.refresh_rounded)),
            Expanded(
              flex: 1,
              child: Container(
                //color: Colors.greenAccent,
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
                      border: InputBorder.none),
                  onEditingComplete: () => startSearch(context),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        //color: Colors.yellow,
        height: 96,
        width: double.infinity,
        child: Row(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                //color: Colors.green,
                iconSize: 25,
                onPressed: () {
                  Provider.of<AppStateManager>(context, listen: false)
                      .switchSearch();
                },
                icon: const Icon(Icons.refresh_rounded)),
            Expanded(
              flex: 1,
              child: SizedBox(
                //color: Colors.yellowAccent,
                height: 100,
                child: Column(
                  children: [
                    TextField(
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
                          border: InputBorder.none),
                      onEditingComplete: () => startSearch(context),
                    ),
                    TextField(
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
                          hintText:
                              AppLocalizations.of(context)!.searchSongHint,
                          border: InputBorder.none),
                      onEditingComplete: () => startSearch(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildButton(BuildContext context) {
    return SizedBox(
      height: 35,
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

  void startSearch(BuildContext context) {
    if (_searchControllerText.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.searchTextTooShort),
      ));
      return;
    }

    //Hide virtual keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    bool isTextSearch =
        Provider.of<AppStateManager>(context, listen: false).isTextSearch;
    if (isTextSearch) {
      Provider.of<AppStateManager>(context, listen: false)
          .startSearchText(_searchControllerText.text);
    } else {
      Provider.of<AppStateManager>(context, listen: false)
          .startSearchSongAuthor(
              _searchControllerAuthor.text, _searchControllerSong.text);
    }
    showSnackBar(
        Provider.of<AppStateManager>(context, listen: false).searchResults);
  }

  Widget buildList(BuildContext context) {
    double _height = 236;
    if (Provider.of<AppStateManager>(context, listen: false)
        .isSearchCompleted) {
      var results =
          Provider.of<AppStateManager>(context, listen: false).searchResults;
      List<Widget> itemTiles = List<Widget>.empty(growable: true);
      /*itemTiles.add(
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  /* Clear the search field */
                },
              ),
              hintText: 'Search...1',
              border: InputBorder.none),
          onEditingComplete: () =>
              Provider.of<AppStateManager>(context, listen: false).goToTab(2),
        ),
      );*/
      for (LyricSearchResult item in results) {
        var provider = Provider.of<AppStateManager>(context, listen: false);

        itemTiles.add(InkWell(
          child: LyricTile(
            item: item,
          ),
          onTap: () {
            logger.i("Clicked on Search result. Song: ${item.song}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LyricDetailScreen(
                  lyric: provider.getLyric(item),
                ),
              ),
            );
          },
        ));
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

  @override
  void dispose() {
    logger.d("Dispose of Search Screen");
    _searchControllerText.dispose();
    super.dispose();
  }

  void showSnackBar(List<LyricSearchResult> results) {
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.noResults),
      ));
    }
  }
}
