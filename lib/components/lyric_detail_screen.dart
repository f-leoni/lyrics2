import 'package:flutter/material.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';
// import 'package:lyrics_2/components/components.dart';

class LyricDetailScreen extends StatelessWidget {
  static MaterialPage page(Lyric lyric) {
    return MaterialPage(
      name: LyricsPages.searchResultsPath,
      key: ValueKey(LyricsPages.home),
      child: LyricDetailScreen(
        lyric: lyric,
      ),
    );
  }

  final Lyric lyric;

  const LyricDetailScreen({
    Key? key,
    required this.lyric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints.expand(width: 350, height: 450),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(lyric.imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Stack(
          children: [
            Text(
              lyric.author,
              style: LyricsTheme.darkTextTheme.bodyText1,
            ),
            Positioned(
              child: Text(
                lyric.title,
                style: LyricsTheme.darkTextTheme.headline2,
              ),
              top: 20,
            ),
            Positioned(
              child: Text(
                lyric.lyric,
                style: LyricsTheme.darkTextTheme.bodyText1,
              ),
              bottom: 30,
              right: 0,
            ),
            Positioned(
              child: Text(
                lyric.imageUrl,
                style: LyricsTheme.darkTextTheme.bodyText1,
              ),
              bottom: 10,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
