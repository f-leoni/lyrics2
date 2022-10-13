import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../lyricstheme.dart';
import 'homepagebody.dart';

final _theme = LyricsTheme.dark();

class LyricsHomePage extends StatefulWidget {
  const LyricsHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LyricsHomePage> createState() => _LyricsHomePageState();
}

class _LyricsHomePageState extends State<LyricsHomePage> {
  Future<http.Response> myFutureResponse =
      http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  Future<http.Response> fetchAlbum() {
    Future<http.Response> response =
        http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    return response;
  }

  Future<http.Response> getFutureResponse(String uri) {
    Future<http.Response> myFutureResponse = Future(() {
      return http.get(Uri.parse(uri));
    });
    return myFutureResponse;
  }

  void getAlbumData(String uri) async {
    http.Response value = await getFutureResponse(
        "https://jsonplaceholder.typicode.com/albums/${uri}");
    print("value.body: ${value.body}");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: _theme.textTheme.headline1),
      ),
      body: homePageBody(),
    );
  }
}
