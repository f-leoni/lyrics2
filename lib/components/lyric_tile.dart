import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics_2/data/memory_repository.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:lyrics_2/models/lyric.dart';
import 'package:lyrics_2/models/lyric_data.dart';
import 'package:lyrics_2/models/lyric_search_result.dart';
import 'package:provider/provider.dart';

class LyricTile extends StatelessWidget {
  final LyricData lyric;
  MemoryRepository repository = MemoryRepository();
  List<Lyric> favorites = List<Lyric>.empty(growable: true);

  LyricTile({Key? key, required this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<MemoryRepository>(context);
    List<Lyric> favorites = repository.findAllFavsLyrics();

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
                        Text(
                          lyric.getSong(),
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              //decoration: textDecoration,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
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
                    buildFavoriteIcon(lyric),
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

  Widget buildFavoriteIcon(LyricData p_lyric) {
    if (repository.isLyricFavoriteById(p_lyric.getId())) {
      return const Icon(
        Icons.favorite,
        color: Colors.red,
      );
    } else {
      return Container();
    }
  }
}
