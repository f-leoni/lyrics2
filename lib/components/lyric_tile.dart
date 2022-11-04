import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:lyrics_2/data/memory_repository.dart';
import 'package:lyrics_2/data/sqlite/sqlite_repository.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:lyrics_2/models/lyric_data.dart';
import 'package:provider/provider.dart';

class LyricTile extends StatelessWidget {
  final LyricData lyric;
  const LyricTile({Key? key, required this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MemoryRepository repository = Provider.of<MemoryRepository>(context);
    SQLiteRepository repository = Provider.of<SQLiteRepository>(context);

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return SizedBox(
          height: 70.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            //color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //Container(width: 5.0, color: Colors.amber),
                    const SizedBox(width: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7185,
                          child: Text(
                            lyric.getSong(),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.roboto(
                                //decoration: textDecoration,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        buildAuthor(),
                        const SizedBox(height: 4.0),
                        Center(
                          child: Container(
                            color: Colors.amber,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 3,
                          ),
                        )
                        //buildImportance(),
                      ],
                    ),
                    buildFavoriteIcon(repository, lyric),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildImportance() {
    return const Text("...");
    /*if (item.importance == Importance.low) {
      return Text('Low', style: GoogleFonts.lato(decoration: textDecoration));
    } else if (item.importance == Importance.medium) {
      return Text('Medium',
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w800, decoration: textDecoration));
    } else if (item.importance == Importance.high) {
      return Text(
        'High',
        style: GoogleFonts.lato(
          color: Colors.red,
          fontWeight: FontWeight.w900,
          decoration: textDecoration,
        ),
      );
    } else {
      throw Exception('This importance type does not exist');
    }*/
  }

  Widget buildAuthor() {
    return Text(
      lyric.getArtist(),
      //style: TextStyle(decoration: textDecoration),
    );
  }

  //Widget buildFavoriteIcon(MemoryRepository repository, LyricData pLyric) {
  Widget buildFavoriteIcon(SQLiteRepository repository, LyricData pLyric) {
    //bool isFavorite = await repository.isLyricFavoriteById(pLyric.getId());
    Widget currIcon = Container();

    return FutureBuilder(
        future: repository.isLyricFavoriteById(pLyric.getId()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data as bool)
              currIcon = Icon(
                Icons.favorite,
                color: Colors.red,
              );
          }
          return currIcon;
        });
  }
}
