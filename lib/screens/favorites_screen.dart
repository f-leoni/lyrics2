import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/components/lyric_tile.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.favoritesPath,
      key: ValueKey(LyricsPages.favoritesPath),
      child: const FavoritesScreen(),
    );
  }

  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String filter = "";
  final _filterController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final Key _filterKey = const ValueKey(0);

  @override
  void initState() {
    _filterController.addListener(() {
      filter = _filterController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building favorites screen");
    final favoritesRepository =
        Provider.of<FirebaseFavoritesRepository>(context);
    final profile = Provider.of<FirebaseUserRepository>(context, listen: false);

    Future<List<Lyric>> favorites =
        favoritesRepository.findAllFavsLyrics(profile.getUser!.email);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: profile.themeData.primaryColor,
            child: TextField(
              key: _filterKey,
              focusNode: myFocusNode,
              controller: _filterController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    icon: const Icon(Icons.filter_alt),
                    onPressed: () =>
                        setState(() => filter = _filterController.text)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear the search field
                    setState(() => _filterController.text = "");
                  },
                ),
                hintText: AppLocalizations.of(context)!.filterHint,
                //border: const UnderlineInputBorder(), //OutlineInputBorder(),
                filled: false,
                fillColor:
                    Theme.of(context).backgroundColor, //Colors.yellow[50],
              ),
              onEditingComplete: () => setState(() {
                filter = _filterController.text;
              }),
              onChanged: (text) {
                setState(() {
                  filter = text;
                  FocusScope.of(context).requestFocus(myFocusNode);
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: FutureBuilder(
              future: favorites,
              builder: (context, snapshot) {
                List<Lyric> favoritesData = List<Lyric>.empty();
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    favoritesData = snapshot.data as List<Lyric>;
                  }
                  if (favoritesData.isEmpty) {
                    return buildEmptyScreen(context);
                  } else {
                    return buildScreen(context, favoritesData);
                  }
                } else {
                  return Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: profile.themeData.primaryColor,
                  ));
                }
              }),
        ),
      ],
    );
  }

  Widget buildScreen(BuildContext context, List<Lyric> favorites) {
    var manager = Provider.of<AppStateManager>(context, listen: false);
    var theme =
        Provider.of<FirebaseUserRepository>(context, listen: false).textTheme;
    List<Widget> itemTiles = List<Widget>.empty(growable: true);
    for (Lyric lyric in favorites) {
      if (lyric.song.toLowerCase().contains(filter.toLowerCase()) |
          lyric.artist.toLowerCase().contains(filter.toLowerCase())) {
        itemTiles.add(Dismissible(
          key: Key(lyric.lyricId.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
              color: Colors.red.shade200,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_forever,
                  color: Provider.of<FirebaseUserRepository>(context,
                          listen: false)
                      .themeData
                      .backgroundColor,
                  size: 25.0)),
          onDismissed: (direction) {
            Provider.of<FirebaseFavoritesRepository>(context, listen: false)
                .deleteLyricFromFavs(lyric);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    '"${lyric.song}" ${AppLocalizations.of(context)!.msgDismissed}',
                    style: theme.button)));
          },
          child: InkWell(
            child: LyricTile(
              lyric: lyric,
              isFavoritePage: true,
            ),
            onTap: () {
              logger
                  .d("Clicked on Favorites result Screen. Song: ${lyric.song}");
              manager.viewLyric(lyric);
              /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowLyricScreen(
                  lyric: Future.value(lyric),
                ),
              ),
            );*/
            },
          ),
        ));
      } else {
        continue;
      }
    }
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
        height: height,
        //color: Colors.green,
        child: Container(
          color: Provider.of<FirebaseUserRepository>(context, listen: false)
              .themeData
              .primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: itemTiles,
          ),
        ));
  }

  Widget buildEmptyScreen(BuildContext context) {
    logger.d("Building empty favorites screen");
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset('assets/lyrics_assets/empty_favorites.png'),
            ),
            const SizedBox(height: 8.0),
            Text(
              AppLocalizations.of(context)!.nothingHere,
              style: Provider.of<FirebaseUserRepository>(context, listen: false)
                  .textTheme
                  .headline1,
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.emptyFavsLine1 +
                  AppLocalizations.of(context)!.emptyFavsLine2,
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              textColor:
                  Provider.of<FirebaseUserRepository>(context, listen: false)
                      .themeData
                      .highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Provider.of<FirebaseUserRepository>(context, listen: false)
                  .themeData
                  .indicatorColor,
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .goToTab(LyricsTab.search);
              },
              child: Text(AppLocalizations.of(context)!.lblSearch),
            ),
          ],
        ),
      ),
    );
  }
}
