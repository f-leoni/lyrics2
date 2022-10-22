import 'package:flutter/material.dart';
import 'package:lyrics_2/models/models.dart';

class ShowLyricScreen extends StatelessWidget {
  static MaterialPage page(Lyric lyric) {
    return MaterialPage(
      name: LyricsPages.showLyricPath,
      key: ValueKey(LyricsPages.showLyricPath),
      child: ShowLyricScreen(lyric: lyric),
    );
  }

  final Lyric lyric;
  const ShowLyricScreen({Key? key, required this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lyric == null) {
      return Container(child: Text("Something went wrong!"));
    } else {
      return Container(
          child: Column(
        children: [
          Text(lyric.title),
          Text(lyric.author),
          Text(lyric.lyric),
        ],
      ));
    }
  }
}
