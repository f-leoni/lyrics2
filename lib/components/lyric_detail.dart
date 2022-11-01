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
        title: Text(widget.lyric.getSong()),
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        SizedBox(
          height: 100,
          width: double.infinity,
          child: Image(image: AssetImage(widget.lyric.imageUrl.toString())),
        ),
        const SizedBox(
          height: 4,
        ),
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
