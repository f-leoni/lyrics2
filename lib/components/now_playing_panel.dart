import 'package:flutter/material.dart';
import 'package:nowplaying/nowplaying_track.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/api/proxy.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';

class NowPlayingPanel extends StatefulWidget {
  final Proxy proxy;

  const NowPlayingPanel({super.key, required this.proxy});

  @override
  State<NowPlayingPanel> createState() => _NowPlayingPanelState();
}

class _NowPlayingPanelState extends State<NowPlayingPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NowPlayingTrack>(
      builder: (context, track, _) {
        if (track.isPlaying) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Consumer<NowPlayingTrack>(
                builder: (context, track, _) {
                  return Container(
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (track.isStopped)
                          Text(AppLocalizations.of(context)!.msgNoPlay),
                        if (!track.isStopped) ...[
                          if (track.title != null)
                            Text(
                              '${track.title ?? "null"} - ${track.artist ?? "null"}',
                            ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 150,
                                height: 30,
                                alignment: Alignment.center,
                                //color: Colors.grey,
                                child: MaterialButton(
                                  textColor:
                                      Provider.of<FirebaseUserRepository>(
                                        context,
                                        listen: false,
                                      ).themeData.highlightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color:
                                      Provider.of<FirebaseUserRepository>(
                                        context,
                                        listen: false,
                                      ).themeData.indicatorColor,
                                  onPressed: () async {
                                    final manager =
                                        Provider.of<AppStateManager>(
                                          context,
                                          listen: false,
                                        );
                                    manager.lastTextSearch =
                                        '${track.artist} ${track.title}';
                                    manager.lastAuthorSearch =
                                        track.artist ?? "null";
                                    manager.lastSongSearch =
                                        track.title ?? "null";
                                    // Consider only first 4 words for title
                                    // (Genius doesn't seem to like long titles too much)
                                    await manager.startSearchSongAuthor(
                                      track.artist ?? "null",
                                      firstFewWords(track.title ?? "null", 4),
                                      widget.proxy,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.lblSearch,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: _iconFrom(track),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.msgNoPlay),
          );
        }
      },
    );
  }

  String firstFewWords(String bigSentence, int numWords) {
    int startIndex = 0, indexOfSpace = -1;
    // Trim at first parenthesis
    int indexOfParenthesis = bigSentence.indexOf('(', 0);
    if (indexOfParenthesis > 0) {
      bigSentence = bigSentence.substring(0, bigSentence.indexOf('(', 0));
    }
    for (int i = 0; i < numWords; i++) {
      indexOfSpace = bigSentence.indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return bigSentence;
      }
      startIndex = indexOfSpace + 1;
    }

    return bigSentence.substring(0, indexOfSpace);
  }

  /*Widget _imageFrom(NowPlayingTrack track) {
    if (track.hasImage) {
      return Image(
          key: Key(track.id ?? "NULL"),
          image: track.image ?? const AssetImage('assets/nope.png'),
          width: 200,
          height: 200,
          fit: BoxFit.contain);
    }

    if (track.isResolvingImage) {
      return const SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    }

    return Text(AppLocalizations.of(context)!.msgNoArtwork,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, color: Colors.white));
  }*/

  Widget _iconFrom(NowPlayingTrack track) {
    if (track.hasIcon) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black)],
          shape: BoxShape.circle,
        ),
        child: Image(
          image: track.icon ?? const AssetImage('assets/nope.png'),
          width: 25,
          height: 25,
          fit: BoxFit.contain,
          color: _fgColorFor(track),
          colorBlendMode: BlendMode.srcIn,
        ),
      );
    }
    return Container();
  }

  Color _fgColorFor(NowPlayingTrack track) {
    switch (track.source) {
      case "com.apple.music":
        return Colors.blue;
      case "com.hughesmedia.big_finish":
        return Colors.red;
      case "com.spotify.music":
        return Colors.green;
      default:
        return Colors.purpleAccent;
    }
  }
}
