import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class InfoScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.infoPath,
      key: ValueKey(LyricsPages.infoPath),
      child: InfoScreen(),
    );
  }

  InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Info!"),
    );
  }
}
