import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/lyric_data.dart';
import 'package:provider/provider.dart';

class LyricTile extends StatelessWidget {
  final LyricData lyric;
  const LyricTile({Key? key, required this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFavoritesRepository repository =
        Provider.of<FirebaseFavoritesRepository>(context);

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        var authorRowOffset = 0.7495;
        return SizedBox(
          height: 70.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            //color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  authorRowOffset,
                              child: Text(
                                lyric.getSong(),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    //decoration: textDecoration,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            buildAuthor(context),
                            const SizedBox(height: 4.0),
                            /*Center(
                              child: Container(
                                color: Colors.amber,
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 3,
                              ),
                            )*/
                            //buildImportance(),
                          ],
                        ),
                      ),
                      buildFavoriteIcon(context, repository, lyric),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAuthor(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7185,
      child: Text(
        lyric.getArtist(),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        /*style: GoogleFonts.roboto(
          //decoration: textDecoration,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),*/
      ),
    );
  }

  Widget buildFavoriteIcon(BuildContext context,
      FirebaseFavoritesRepository repository, LyricData pLyric) {
    FirebaseUserRepository profileManager =
        Provider.of<FirebaseUserRepository>(context, listen: false);
    Widget currIcon = Container();
    return FutureBuilder(
        future: repository.isLyricFavoriteById(
            pLyric.getId(), profileManager.getUser!.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data as bool) {
              currIcon = const Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              );
            } else {
              currIcon = const SizedBox(width: 1);
            }
          } else {
            currIcon = SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: profileManager.themeData.primaryColor,
                ));
          }
          return currIcon;
        });
  }
}
