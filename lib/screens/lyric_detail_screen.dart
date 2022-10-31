import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';
// import 'package:lyrics_2/components/components.dart';

class LyricDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // 3
    return Center(
      child: FutureBuilder<Lyric>(
          future: lyric,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return createLyricPage(context, snapshot.data);
            } else {
              return Container();
            }
          }),
    );
  }
}

Widget createLyricPage(BuildContext context, Lyric? lyric) {
  int _alpha = 180;
  BlendMode blend = BlendMode.darken;
  if (lyric == null) {
    return Center(child: Text(AppLocalizations.of(context)!.errNoLyric));
  }
  BoxDecoration decoration = const BoxDecoration();
  if (lyric.imageUrl == "") {
    decoration = BoxDecoration(
        image: DecorationImage(
      image: const AssetImage("assets/lyrics_assets/logo.png"),
      colorFilter: ColorFilter.mode(Colors.black.withAlpha(_alpha), blend),
      fit: BoxFit.cover,
    ));
  } else {
    decoration = BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(lyric.imageUrl),
        colorFilter: ColorFilter.mode(Colors.black.withAlpha(_alpha), blend),
        fit: BoxFit.cover,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );
  }

  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      //constraints: const BoxConstraints.expand(width: 350, height: 450),
      decoration: decoration,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                alignment: Alignment.centerLeft,
                iconSize: 22,
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                child: Text(
                  lyric.author,
                  style: LyricsTheme.darkTextTheme.bodyText1,
                ),
                height: 24,
              ),
            ],
          ),
          SizedBox(
            child: Text(
              lyric.title,
              style: LyricsTheme.darkTextTheme.headline3,
            ),
            height: 40,
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal
              child: Text(
                lyric.lyric.replaceAll("\\r\\\\n", "\r\n"),
                style: LyricsTheme.darkTextTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
