import 'package:flutter/material.dart';
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
  final double iconSize = 25;
  const LyricTile({super.key, required this.lyric, required this.isFavoritePage});
  static const AssetImage chartLyricsIcon = AssetImage('assets/lyrics_assets/chartlyrics_logo.png');
  static const AssetImage geniusIcon = AssetImage('assets/lyrics_assets/genius_logo.png');

  @override
  Widget build(BuildContext context) {
    logger.t("building tile");
    FirebaseFavoritesRepository repository =
        Provider.of<FirebaseFavoritesRepository>(context);
    var users = Provider.of<FirebaseUserRepository>(context);

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        ThemeData theme = users.themeData;
        return Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
          child: Card(
            color: theme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: theme.focusColor),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: SizedBox(
                height: 70.0,
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
                            flex: 2,
                            child: buildTitle(context, lyric),
                          ),
                          Expanded(
                              flex: 1,
                              child: buildAuthor(context)),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex:2,child:Container(
                              //color: Colors.blue,
                              child:
                                  buildFavoriteIcon(context, repository, lyric),
                            )),
                            Expanded(
                              flex: 1, child: buildProxyIcon(context, lyric)),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
    AppStateManager appStateManager = Provider.of<AppStateManager>(context, listen: false);
    Widget currIcon = Container();
    return FutureBuilder(
        future: repository.isLyricFavoriteById(
            pLyric.getId(), profileManager.getUser!.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data as bool) {
              currIcon = Center(
                child: Icon(appStateManager.icnFavorite,
                  color: Colors.red.shade700,
                  size: iconSize,
                ),
              );
            } else {
              //currIcon = Center(child: SizedBox(width: iconSize, height: iconSize));
              currIcon = Center(
                child: Icon(
                  appStateManager.icnNoFavorite,
                  color: Colors.black12,
                  size: iconSize,
                ),
              );

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
    AssetImage providerImg = chartLyricsIcon;
    double height = 30;
    if (lyric.getProxy() == Proxies.genius) {
      providerImg = geniusIcon;
    }
    return Center(
      child: Image(
        image: providerImg,
        height: height,
        alignment: Alignment.center,
      ),
    );
  }

  buildTitle(BuildContext context, LyricData lyric) {
    var users = Provider.of<FirebaseUserRepository>(context);
    return Row(children:[
      Expanded(flex: 1, child: Icon(Icons.music_note_rounded, size: 15, color: users.themeData.indicatorColor)),
      Expanded(flex: 8, child: Text(lyric.getSong(),
          softWrap: true,
          //overflow: TextOverflow.ellipsis,
          style: users.textTheme.headlineLarge))
    ]);
  }

  Widget buildAuthor(BuildContext context) {
    var users = Provider.of<FirebaseUserRepository>(context);
    return Row(children: [
        Expanded(flex: 1, child: Icon(Icons.mic, size: 15, color: users.themeData.indicatorColor)),
        Expanded(flex: 8, child: Text(lyric.getArtist(),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: users.textTheme.headlineMedium))
      ]
    );
  }

}
