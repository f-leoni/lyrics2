import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:lyrics_2/components/lyric_tile.dart';
import 'package:lyrics_2/data/memory_repository.dart';
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
    final repository = Provider.of<MemoryRepository>(context);
    final List<Lyric> favorites = repository.findAllFavsLyrics();
    if (favorites.isEmpty) {
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
                  Provider.of<TabManager>(context, listen: false).goToTab(2);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      List<Widget> itemTiles = List<Widget>.empty(growable: true);
      for (Lyric lyric in favorites) {
        itemTiles.add(InkWell(
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
        ));
      }
      double _height = MediaQuery.of(context).size.height; //, 236;
      return SizedBox(
          height: _height,
          //color: Colors.green,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: itemTiles,
          ));
    }
  }
}
