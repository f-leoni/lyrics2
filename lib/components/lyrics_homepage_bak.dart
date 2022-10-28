import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'homepagebody.dart';

final _theme = LyricsTheme.dark();

class LyricsHomePage extends StatefulWidget {
  const LyricsHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LyricsHomePage> createState() => _LyricsHomePageState();
}

class _LyricsHomePageState extends State<LyricsHomePage> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
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
        "https://jsonplaceholder.typicode.com/albums/$uri");
    logger.v("getAlbumData($uri) value.body: ${value.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: _theme.textTheme.headline1),
      ),
      body: homePageBody(),
    );
  }
}
