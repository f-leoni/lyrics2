import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return Column(
      children: [
        Text(lyric.title),
        Text(lyric.author),
        Text(lyric.lyric),
      ],
    );
  }
}
