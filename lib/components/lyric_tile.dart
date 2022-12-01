import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics2/api/proxies.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/lyric_data.dart';
import 'package:provider/provider.dart';

class LyricTile extends StatelessWidget {
  final LyricData lyric;
  final bool isFavoritePage;
  final double iconSize = 40;

  const LyricTile({Key? key, required this.lyric, required this.isFavoritePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.v("building tile");
    FirebaseFavoritesRepository repository =
        Provider.of<FirebaseFavoritesRepository>(context);

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        ThemeData theme =
            Provider.of<FirebaseUserRepository>(context, listen: false)
                .themeData;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                border: Border.all(color: theme.focusColor),
                borderRadius: const BorderRadius.all(Radius.circular(15.0))),
            //color: Colors.red[50],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: SizedBox(
                height: 90.0,
                //width: MediaQuery.of(context).size.width * 0.94,
                //color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: buildTitle(lyric),
                          ),
                          Expanded(flex: 1, child: buildAuthor(context)),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              //color: Colors.blue,
                              child:
                                  buildFavoriteIcon(context, repository, lyric),
                            ),
                            Expanded(
                                flex: 1, child: buildProxyIcon(context, lyric)),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAuthor(BuildContext context) {
    return Text(
      lyric.getArtist(),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildFavoriteIcon(BuildContext context,
      FirebaseFavoritesRepository repository, LyricData pLyric) {
    if (isFavoritePage) {
      return Center(
        child: Icon(
          Provider.of<AppStateManager>(context, listen: false).icnFavorite,
          color: Colors.red,
          size: iconSize,
        ),
      );
    }
    FirebaseUserRepository profileManager =
        Provider.of<FirebaseUserRepository>(context, listen: false);
    Widget currIcon = Container();
    return FutureBuilder(
        future: repository.isLyricFavoriteById(
            pLyric.getId(), profileManager.getUser!.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data as bool) {
              currIcon = Center(
                child: Icon(
                  Provider.of<AppStateManager>(context, listen: false)
                      .icnFavorite,
                  color: Colors.red,
                  size: iconSize,
                ),
              );
            } else {
              currIcon = SizedBox(width: iconSize);
            }
          } else {
            currIcon = SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: profileManager.themeData.primaryColor,
                ));
          }
          return currIcon;
        });
  }

  buildProxyIcon(BuildContext context, LyricData lyric) {
    AssetImage providerImg =
        const AssetImage('assets/lyrics_assets/chartlyrics_logo.png');
    double height = 30;
    if (lyric.getProxy() == Proxies.genius) {
      providerImg = const AssetImage('assets/lyrics_assets/genius_logo.png');
      height = 30;
    }
    return Center(
      child: Image(
        image: providerImg,
        height: height,
        alignment: Alignment.center,
      ),
    );
  }

  buildTitle(LyricData lyric) {
    return Text(
      lyric.getSong(),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
          //decoration: textDecoration,
          fontSize: 18.0,
          fontWeight: FontWeight.bold),
    );
  }
}
