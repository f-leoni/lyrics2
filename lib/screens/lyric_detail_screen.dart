import 'package:flutter/material.dart';
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
              return createLyricPage(snapshot.data);
            } else {
              return Container();
            }
          }),
    );
  }
}

Widget createLyricPage(Lyric? lyric) {
  if (lyric == null) {
    return Container();
  }
  return Container(
    padding: const EdgeInsets.all(16),
    constraints: const BoxConstraints.expand(width: 350, height: 450),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(lyric.imageUrl),
        colorFilter:
            ColorFilter.mode(Colors.black.withAlpha(128), BlendMode.darken),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: Column(
      children: [
        SizedBox(
          child: Text(
            lyric.author,
            style: LyricsTheme.darkTextTheme.bodyText1,
          ),
          height: 20,
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
  );
}
