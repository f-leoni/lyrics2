import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/sqlite_favorites_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/lyricstheme.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';

class ShowLyricScreen extends StatefulWidget {
  static MaterialPage page(Future<Lyric> lyric) {
    return MaterialPage(
      name: LyricsPages.showLyricPath,
      key: ValueKey(LyricsPages.showLyricPath),
      child: ShowLyricScreen(lyric: lyric),
    );
  }

  final Future<Lyric>? lyric;

  const ShowLyricScreen({
    Key? key,
    required this.lyric,
  }) : super(key: key);

  @override
  State<ShowLyricScreen> createState() => _ShowLyricScreenState();
}

class _ShowLyricScreenState extends State<ShowLyricScreen>
    with TickerProviderStateMixin {
  double _fontSize = 15.0;
  double _baseFontSize = 15.0;
  final double _minFontSize = 11.0;
  final double _maxFontSize = 35.0;
  bool? isFavorite;
  ImageProvider<Object> bgImage =
      const AssetImage("assets/lyrics_assets/logo.png");
  bool bgImageCreated = false;
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  void _runAnimation() async {
    for (int i = 0; i < 1; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building ShowLyric Screen");
    _runAnimation();
    return Center(
      child: createLyricPage(context, widget.lyric!),
    );
  }

  Widget createSpinner(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor:
          Provider.of<SQLiteSettingsRepository>(context, listen: false)
              .themeData
              .primaryColor,
    );
  }

  Widget createLyricPage(BuildContext context, Future<Lyric> lyric) {
    int alpha = 180;
    BlendMode blend = BlendMode.darken;
    BoxDecoration decoration = BoxDecoration(
        image: DecorationImage(
      image: const AssetImage("assets/lyrics_assets/logo.png"),
      colorFilter: ColorFilter.mode(Colors.black.withAlpha(alpha), blend),
      fit: BoxFit.cover,
    ));
    final favorites = Provider.of<SQLiteFavoritesRepository>(context);
    final manager = Provider.of<AppStateManager>(context, listen: false);
    final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    final theme = users.themeData;
    //isFavorite ??= await checkIfFavorite(favorites, await lyric);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: lyric,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  Lyric currLyric = snapshot.data as Lyric;
                  currLyric.owner = "";
                  return buildPage(currLyric, manager, decoration, alpha, blend,
                      context, favorites);
                } else {
                  //container hasn't data
                  /*return buildPage(Lyric.empty, manager, decoration, alpha,
                      blend, context, favorites);*/
                  return Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: theme.primaryColor,
                  ));
                }
              } else {
                // Snapshot  State is not done
                /*return buildPage(Lyric.empty, manager, decoration, alpha, blend,
                    context, favorites);*/
                return Center(
                    child: CircularProgressIndicator.adaptive(
                  backgroundColor: theme.primaryColor,
                ));
              }
            }),
      ),
    );
  }

  Container buildPage(
      Lyric currLyric,
      AppStateManager manager,
      BoxDecoration decoration,
      int alpha,
      BlendMode blend,
      BuildContext context,
      SQLiteFavoritesRepository favorites) {
    //var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    currLyric.owner = "";
    logger.d("lyric is: ${currLyric.song}");
    if (!bgImageCreated) {
      try {
        bgImage = getBackgroundImage(currLyric).image;
      } catch (e) {
        logger.e("Error Creating background image ${e.hashCode}");
      }
      bgImageCreated = true;
    }
    manager.viewedLyric = currLyric;
    manager.isViewingLyric = true;
    if (currLyric.imageUrl == "") {
      logger.w("lyric.imageUrl is void!");
    } else {
      try {
        decoration = BoxDecoration(
          color: Colors.black87,
          image: DecorationImage(
            image: bgImage,
            colorFilter: ColorFilter.mode(Colors.black.withAlpha(alpha), blend),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        );
      } on Exception catch (e) {
        logger.w(
            "Image at ${currLyric.imageUrl} cannot be retrieved! ${e.toString()}");
      }
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
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
                color: Provider.of<SQLiteSettingsRepository>(context,
                        listen: false)
                    .themeData
                    .highlightColor,
                onPressed: () {
                  final manager =
                      Provider.of<AppStateManager>(context, listen: false);
                  manager.isViewingLyric = false;
                  manager.viewedLyric = Lyric.empty;
                  Navigator.pop(context);
                },
              ),
              buildArtist(currLyric),
              buildFavoriteButton(favorites, currLyric),
            ],
          ),
          SizedBox(
            height: 60,
            child: Text(
              currLyric.song,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: LyricsTheme.darkTextTheme.headline2,
            ),
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
                    fontSize: _fontSize,
                    fontWeight: FontWeight.normal,
                    color: Provider.of<SQLiteSettingsRepository>(context,
                            listen: false)
                        .themeData
                        .highlightColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image getBackgroundImage(Lyric currLyric) {
    Image img = Image.network(
      currLyric.imageUrl,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) =>
              Image.asset("assets/lyrics_assets/logo.png"),
    );

    return img;
  }

  Widget buildFavoriteButton(SQLiteFavoritesRepository favorites, Lyric lyric) {
    return FutureBuilder(
        future: checkIfFavorite(favorites, lyric),
        builder: (context, snapshot) {
          Widget tempIcon = Container();
          if (isFavorite == null) {
            tempIcon = CircularProgressIndicator.adaptive(
              backgroundColor:
                  Provider.of<SQLiteSettingsRepository>(context, listen: false)
                      .themeData
                      .primaryColor,
            );
          } else if (isFavorite == true) {
            tempIcon = Icon(
                Provider.of<AppStateManager>(context, listen: false)
                    .icnFavorite,
                size: 40,
                color: Colors.red);
          } else {
            tempIcon = Icon(
                Provider.of<AppStateManager>(context, listen: false)
                    .icnNoFavorite,
                size: 40,
                color: Colors.red);
          }
          Widget currIcon = tempIcon;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              isFavorite = snapshot.data as bool;
            } else {
              isFavorite = true;
            }
            if (isFavorite!) {
              currIcon = Icon(
                  Provider.of<AppStateManager>(context, listen: false)
                      .icnFavorite,
                  size: 40,
                  color: Colors.red);
            }
          }
          return IconButton(
            icon: RotationTransition(
                turns: Tween(begin: 0.0, end: -.1)
                    .chain(CurveTween(curve: Curves.elasticIn))
                    .animate(_animationController),
                child: currIcon),
            alignment: Alignment.centerRight,
            iconSize: 22,
            color: Provider.of<SQLiteSettingsRepository>(context, listen: false)
                .themeData
                .primaryColor,
            onPressed: () {
              logger.i(
                  "Changing favorite state of '${lyric.song}' to '${(!isFavorite!).toString()}'");
              if (isFavorite!) {
                favorites.deleteLyricFromFavs(lyric);
                setState(() {
                  isFavorite = false;
                });
              } else {
                lyric.owner =
                    ""; /*Provider.of<SQLiteSettingsRepository>(context,
                        listen: false)
                    .getUser!
                    .email!;*/
                favorites.insertLyricInFavs(lyric);
                setState(() {
                  isFavorite = true;
                });
              }
            },
          );
        });
  }

  Future<bool> checkIfFavorite(
      SQLiteFavoritesRepository favorites, Lyric lyric) async {
    if (isFavorite != null) return Future.value(isFavorite);
    //var userManager = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    isFavorite = await favorites.isLyricFavoriteById(lyric.lyricId, "");
    return Future.value(isFavorite);
  }

  Widget buildArtist(Lyric currLyric) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 24,
        //width: 261,
        child: Text(
          currLyric.artist,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: LyricsTheme.darkTextTheme.bodyLarge,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
