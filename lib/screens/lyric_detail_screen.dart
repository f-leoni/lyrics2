import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrics_2/components/logger.dart';
//import 'package:lyrics_2/data/memory_repository.dart';
import 'package:lyrics_2/data/sqlite/sqlite_repository.dart';
import 'package:lyrics_2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';

class LyricDetailScreen extends StatefulWidget {
  static MaterialPage page(Future<Lyric> lyric) {
    return MaterialPage(
      name: LyricsPages.searchResultsPath,
      key: ValueKey(LyricsPages.home),
      child: LyricDetailScreen(
        lyric: lyric,
      ),
    );
  }

  final Future<Lyric>? lyric;

  const LyricDetailScreen({
    Key? key,
    required this.lyric,
  }) : super(key: key);

  @override
  State<LyricDetailScreen> createState() => _LyricDetailScreenState();
}

class _LyricDetailScreenState extends State<LyricDetailScreen> {
  double _fontSize = 13.0;
  double _baseFontSize = 13.0;
  double _minFontSize = 11.0;
  double _maxFontSize = 24.0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: createLyricPage(context, widget.lyric!),
      /*FutureBuilder<Lyric>(
          future: widget.lyric,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return createLyricPage(context, snapshot.data!);
              } else {
                return createLyricPage(context, Lyric.empty);
              }
            } else {
              return createSpinner(context);
            }
          }),*/
    );
  }

  Widget createSpinner(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  Widget createLyricPage(BuildContext context, Future<Lyric> lyric) {
    int _alpha = 180;
    BlendMode blend = BlendMode.darken;
    BoxDecoration decoration = BoxDecoration(
        image: DecorationImage(
      image: const AssetImage("assets/lyrics_assets/logo.png"),
      colorFilter: ColorFilter.mode(Colors.black.withAlpha(_alpha), blend),
      fit: BoxFit.cover,
    ));
    //final favorites = Provider.of<MemoryRepository>(context);
    final favorites = Provider.of<SQLiteRepository>(context);
    final manager = Provider.of<AppStateManager>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
          future: lyric,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Lyric currLyric = snapshot.data as Lyric;
                manager.viewedLyric = currLyric;
                manager.isViewingLyric = true;
                if (currLyric.imageUrl == "") {
                  logger.w("lyric.imageUrl is void!");
                } else {
                  try {
                    decoration = BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currLyric.imageUrl),
                        colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(_alpha), blend),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    );
                  } on Exception catch (e) {
                    logger.w(
                        "Image at ${currLyric.imageUrl} cannot be retrieved! ${e.toString()}");
                  }
                }
                return Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16),
                  //constraints: const BoxConstraints.expand(width: 350, height: 450),
                  decoration: decoration,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            alignment: Alignment.centerLeft,
                            iconSize: 22,
                            color: Colors.white,
                            onPressed: () {
                              final manager = Provider.of<AppStateManager>(
                                  context,
                                  listen: false);
                              manager.isViewingLyric = false;
                              manager.viewedLyric = Lyric.empty;
                              Navigator.pop(context);
                            },
                          ),
                          buildArtist(currLyric),
                          //const Expanded(flex:1,child: Container()),
                          buildButton(favorites, currLyric),
                        ],
                      ),
                      SizedBox(
                        child: Text(
                          currLyric.song,
                          style: LyricsTheme.darkTextTheme.headline3,
                        ),
                        height: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onScaleStart: (details) {
                            _baseFontSize = _fontSize;
                          },
                          onScaleUpdate: (details) {
                            setState(() {
                              _fontSize = _baseFontSize * details.scale;
                              if (_fontSize > _maxFontSize) {
                                _fontSize = _maxFontSize;
                              }
                              if (_fontSize < _minFontSize) {
                                _fontSize = _minFontSize;
                              }
                            });
                          },
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical, //.horizontal
                            child: Text(
                              currLyric.lyric.replaceAll("\\r\\\\n", "\r\n"),
                              //style: LyricsTheme.darkTextTheme.bodyText1,
                              style: GoogleFonts.roboto(
                                //decoration: textDecoration,
                                fontSize: _fontSize,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                //container hasn't data
                return Container(color: Colors.black);
              }
            } else {
              // Snapshot  State is not done
              return Container(color: Colors.black);
            }
          }),
    );
  }

  //Widget createButton(MemoryRepository favorites, Lyric lyric) {
  Widget buildButton(SQLiteRepository favorites, Lyric lyric) {
    return FutureBuilder(
        future: checkIfFavorite(favorites, lyric),
        builder: (context, snapshot) {
          Icon currIcon = Icon(Icons.favorite_outline, color: Colors.red);
          bool isFavorite = false;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              isFavorite = snapshot.data as bool;
            } else {
              isFavorite = false;
            }
            if (isFavorite) {
              currIcon = Icon(Icons.favorite, color: Colors.red);
            }
          }
          return IconButton(
            icon: currIcon,
            alignment: Alignment.centerRight,
            iconSize: 22,
            color: Colors.white,
            onPressed: () {
              logger.i(
                  "Changing favorite state of ${lyric.song} to ${(!isFavorite).toString()}");
              if (isFavorite) {
                favorites.deleteLyricFromFavs(lyric);
                setState(() {
                  isFavorite = false;
                });
              } else {
                favorites.insertLyricInFavs(lyric);
                setState(() {
                  isFavorite = true;
                });
              }
            },
          );
        });
  }

  //Future<bool> checkIfFavorite(MemoryRepository favorites, Lyric lyric) async =>
  Future<bool> checkIfFavorite(SQLiteRepository favorites, Lyric lyric) async =>
      await favorites.isLyricFavoriteById(lyric.lyricId);

  Widget buildArtist(Lyric currLyric) {
    return SizedBox(
      child: Text(
        currLyric.artist,
        style: LyricsTheme.darkTextTheme.bodyText1,
      ),
      height: 24,
    );
  }
}
