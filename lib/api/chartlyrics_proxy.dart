library lyrics_library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:lyrics_2/models/models.dart';

class chartLyricsProxy {
  String searchBase = "http://api.chartlyrics.com/apiv1.asmx/SearchLyric?";
  String searchDirectBase =
      "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?";
  String SearchTextBase =
      "http://api.chartlyrics.com/apiv1.asmx/SearchLyricText?";
  String getLyricBase = "http://api.chartlyrics.com/apiv1.asmx/GetLyric?";
  //String addLyricBase = "http://api.chartlyrics.com/apiv1.asmx/AddLyric?";

  String _lyricRoot = "ArrayOfSearchLyricResult";
  String _lyricSearchResult = "SearchLyricResult";
  String _lyricGetResult = "GetLyricResult";
  //String _lyricAuthor = "Artist";
  //String _lyricID = "TrackId";
  String _lyricTitle = "Song";
  //String _lyricText = "TrackId";
  final myTransformer = Xml2Json();

  // Futures helper
  Future<http.Response> _getFutureResponse(String uri) {
    Future<http.Response> myFutureResponse = new Future(() {
      return http.get(Uri.parse(uri));
    });

    return myFutureResponse;
  }

  // Search by text and title
  Future<String> _searchLyric(String artist, String song) async {
    http.Response value =
        await _getFutureResponse(searchBase + "artist=${artist}&song=${song}");
    if (value.statusCode != 200) {
      throw new LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

  Future<String> _searchLyricDirect(String artist, String song) async {
    http.Response value = await _getFutureResponse(
        searchDirectBase + "artist=${artist}&song=${song}");
    if (value.statusCode != 200) {
      throw new LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

  Future<String> _searchLyricText(String text) async {
    http.Response value =
        await _getFutureResponse(SearchTextBase + "lyricText=${text}");
    if (value.statusCode != 200) {
      throw new LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

  Future<Lyric> getLyric(LyricSearchResult lyric) async {
    http.Response value = await _getFutureResponse(getLyricBase +
        "lyricId=${lyric.lyricId}&lyricCheckSum=${lyric.lyricChecksum}");
    if (value.statusCode != 200) {
      throw new LyricException(value.statusCode, value.body);
    }
    Map<String, dynamic> jsonResults = _convertToJson(value.body);
    Lyric out = Lyric.fromJson(jsonResults[_lyricGetResult]);
    return out;
  }

  Future<List<LyricSearchResult>> simpleSearchText(String song) async {
    List<LyricSearchResult> result =
        List<LyricSearchResult>.empty(growable: true);
    String searchXML = await _searchLyricText(song);
    Map<String, dynamic> jsonResults = _convertToJson(searchXML);
    var jsonSearchResults = jsonResults[_lyricRoot][_lyricSearchResult];
    if (!(jsonSearchResults is List)) {
      return List<LyricSearchResult>.empty();
    }
    for (Map<String, dynamic> item in jsonSearchResults) {
      if (item.keys.contains(_lyricTitle) && item[_lyricTitle] != null) {
        //print(
        //    "Titolo: ${item[lyricTitle]} - Autore: ${item[lyricAuthor]} (${item[lyricID]})");
        result.add(LyricSearchResult.fromJson(item));
      }
    }
    return Future.value(result);
  }

  Future<List<LyricSearchResult>> simpleSearch(
      String author, String song) async {
    List<LyricSearchResult> result =
        List<LyricSearchResult>.empty(growable: true);
    String searchXML = await _searchLyric(author, song);
    Map<String, dynamic> jsonResults = _convertToJson(searchXML);
    var jsonSearchResults = jsonResults[_lyricRoot][_lyricSearchResult];
    if (!(jsonSearchResults is List)) {
      return List<LyricSearchResult>.empty();
    }
    for (Map<String, dynamic> item in jsonSearchResults) {
      if (item.keys.contains(_lyricTitle) && item[_lyricTitle] != null) {
        //print(
        //    "Titolo: ${item[lyricTitle]} - Autore: ${item[lyricAuthor]} (${item[lyricID]})");
        result.add(LyricSearchResult.fromJson(item));
      }
    }
    return Future.value(result);
  }

  // Parse XML, convert it to Json
  Map<String, dynamic> _convertToJson(String searchXML) {
    myTransformer.parse(searchXML);
    //var json = myTransformer.toParkerWithAttrs();
    Map<String, dynamic> jsonResults =
        jsonDecode(myTransformer.toParkerWithAttrs());
    return jsonResults;
  }
}
