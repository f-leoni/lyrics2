import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:lyrics_2/components/lyric_tile.dart';
//import 'package:lyrics_2/data/memory_repository.dart';
import 'package:lyrics_2/data/sqlite/sqlite_repository.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/screens/lyric_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final repository = Provider.of<MemoryRepository>(context);
    final repository = Provider.of<SQLiteRepository>(context);
    Future<List<Lyric>> favorites = repository.findAllFavsLyrics();
    return FutureBuilder(
        future: favorites,
        builder: (context, snapshot) {
          List<Lyric> favoritesData = new List<Lyric>.empty();
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              favoritesData = snapshot.data as List<Lyric>;
            }
            if (favoritesData.isEmpty) {
              return createEmptyScreen(context);
            } else {
              return createScreen(context, favoritesData);
            }
          } else {
            return Text("Wait Please");
          }
        });
  }

  Widget createScreen(BuildContext context, List<Lyric> favorites) {
    List<Widget> itemTiles = List<Widget>.empty(growable: true);
    for (Lyric lyric in favorites) {
      itemTiles.add(Dismissible(
        key: Key(lyric.lyricId.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete_forever,
                color: Colors.white, size: 25.0)),
        onDismissed: (direction) {
          Provider.of<SQLiteRepository>(context, listen: false)
              .deleteLyricFromFavs(lyric);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${lyric.song} dismissed')));
        },
        child: InkWell(
          child: LyricTile(
            lyric: lyric,
          ),
          onTap: () {
            logger.i("Clicked on Search result. Song: ${lyric.song}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LyricDetailScreen(
                  lyric: Future.value(lyric),
                ),
              ),
            );
          },
        ),
      ));
    }
    double _height = MediaQuery.of(context).size.height;

    return SizedBox(
        height: _height,
        //color: Colors.green,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: itemTiles,
        ));
  }

  Widget createEmptyScreen(BuildContext context) {
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
              style: const TextStyle(fontSize: 21.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.emptyFavsLine1 +
                  AppLocalizations.of(context)!.emptyFavsLine2,
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              textColor: Colors.white,
              child: Text(AppLocalizations.of(context)!.lblSearch),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.green,
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false).goToTab(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
