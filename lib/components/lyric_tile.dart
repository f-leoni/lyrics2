import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:lyrics_2/models/lyric_search_result.dart';
import 'package:provider/provider.dart';

class LyricTile extends StatelessWidget {
  final LyricSearchResult item;

  const LyricTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return SizedBox(
          height: 70.0,
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
                        item.song,
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
                          width: 150,
                          height: 2,
                        ),
                      )
                      //buildImportance(),
                    ],
                  ),
                ],
              ),
            ],
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
      item.artist,
      //style: TextStyle(decoration: textDecoration),
    );
  }
}
