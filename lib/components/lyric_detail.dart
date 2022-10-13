import 'package:flutter/material.dart';
import 'package:lyrics_2/models/lyric.dart';

class LyricDetail extends StatefulWidget {
  final Lyric lyric;

  const LyricDetail({Key? key, required this.lyric}) : super(key: key);

  @override
  _LyricDetailState createState() {
    return _LyricDetailState();
  }
}

class _LyricDetailState extends State<LyricDetail> {
  @override
  Widget build(BuildContext context) {
    // 1
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lyric.title),
      ),
      // 2
      body: SafeArea(
          // 3
          child: Column(children: <Widget>[
        // 4
        SizedBox(
          height: 100,
          width: double.infinity,
          child: Image(image: AssetImage(widget.lyric.imageUrl.toString())),
        ),
        // 5
        const SizedBox(
          height: 4,
        ),
        // 6
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, //.horizontal
            child: Text(
              widget.lyric.lyric,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        )
      ])),
    );
  }
}
