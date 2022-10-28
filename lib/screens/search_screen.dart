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
  final _searchController = TextEditingController();
  String _searchString = "";
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        _searchString = _searchController.text;
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
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: Column(children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        // Clear the search field
                        _searchController.text = "";
                      },
                    ),
                    hintText: AppLocalizations.of(context)!.searchHint,
                    border: InputBorder.none),
                onEditingComplete: () => startSearch(context),
              ),
              buildButton(context),
              Consumer<AppStateManager>(
                  builder: (context, appStateManager, child) {
                return buildList(context);
              })
            ])),
          )),
    );
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
    FocusManager.instance.primaryFocus?.unfocus();
    Provider.of<AppStateManager>(context, listen: false)
        .startSearch(_searchString);
  }

  Widget buildList(BuildContext context) {
    double _height = 284;
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
    _searchController.dispose();
    super.dispose();
  }
}
