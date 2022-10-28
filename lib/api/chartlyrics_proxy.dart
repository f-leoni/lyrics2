library lyrics_library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:logger/logger.dart';

class ChartLyricsProxy {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  static String apiBase = "http://api.chartlyrics.com/apiv1.asmx/";
  String searchBase = apiBase + "SearchLyric?";
  String searchDirectBase = apiBase + "SearchLyricDirect?";
  String searchTextBase = apiBase + "SearchLyricText?";
  String getLyricBase = apiBase + "GetLyric?";
  final String _lyricRoot = "ArrayOfSearchLyricResult";
  final String _lyricSearchResult = "SearchLyricResult";
  final String _lyricGetResult = "GetLyricResult";
  final String _lyricTitle = "Song";
  final String _lyricAuthor = "Artist";
  final String _lyricID = "TrackId";
  final myTransformer = Xml2Json();

  // Futures helper
  Future<http.Response> _getFutureResponse(String uri) {
    Future<http.Response> myFutureResponse = Future(() {
      Future<http.Response> result;
      try {
        result = http.get(Uri.parse(uri));
        return result;
      } on http.ClientException catch (e) {
        logger.e("Error in _getFutureResponse on http.get: ${e.message} ");
        throw LyricException(e.hashCode, e.message);
      }
    });
    return myFutureResponse;
  }

  // Search by text and title
  Future<String> _searchLyric(String artist, String song) async {
    http.Response value =
        await _getFutureResponse(searchBase + "artist=$artist&song=$song");
    if (value.statusCode != 200) {
      logger.e(
          "Error in _searchLyric($artist, $song): ${value.body} (${value.statusCode}");
      throw LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

// Search lyrics by artist and title
  Future<String> _searchLyricDirect(String artist, String song) async {
    http.Response value = await _getFutureResponse(
        searchDirectBase + "artist=$artist&song=$song");
    if (value.statusCode != 200) {
      logger.e(
          "Error in _searchLyricDirect($artist, $song): ${value.body} (${value.statusCode}");
      throw LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

// Search lyrics by text
  Future<String> _searchLyricText(String text) async {
    http.Response value =
        await _getFutureResponse(searchTextBase + "lyricText=$text");
    if (value.statusCode != 200) {
      logger.e(
          "Error in _searchLyricText($text): ${value.body} (${value.statusCode}");
      throw LyricException(value.statusCode, value.body);
    }
    return value.body;
  }

  // Get complete lyric data by Id and Checksum
  Future<Lyric> getLyric(LyricSearchResult lyric) async {
    http.Response value = await _getFutureResponse(getLyricBase +
        "lyricId=${lyric.lyricId}&lyricCheckSum=${lyric.lyricChecksum}");
    if (value.statusCode != 200) {
      logger.e(
          "Error in getLyric([${lyric.song}]): ${value.body} (${value.statusCode}");
      throw LyricException(value.statusCode, value.body);
    }
    Map<String, dynamic> jsonResults = _convertToJson(value.body);
    Lyric out = Lyric.fromJson(jsonResults[_lyricGetResult]);
    return out;
  }

  // Simplified search lyrics by text
  Future<List<LyricSearchResult>> simpleSearchText(String song) async {
    List<LyricSearchResult> result =
        List<LyricSearchResult>.empty(growable: true);
    String searchXML = await _searchLyricText(song);
    Map<String, dynamic> jsonResults = _convertToJson(searchXML);
    var jsonSearchResults = jsonResults[_lyricRoot][_lyricSearchResult];
    if (jsonSearchResults is! List) {
      logger.e("Error in simpleSearchText($song): result is not a list");
      return List<LyricSearchResult>.empty();
    }
    for (Map<String, dynamic> item in jsonSearchResults) {
      if (item.keys.contains(_lyricTitle) && item[_lyricTitle] != null) {
        logger.v(
            "simpleSearchText found Lyric - title: ${item[_lyricTitle]} - Author: ${item[_lyricAuthor]} (Id: ${item[_lyricID]})");
        result.add(LyricSearchResult.fromJson(item));
      }
    }
    return Future.value(result);
  }

//Simplified search lyrics by author and title
  Future<List<LyricSearchResult>> simpleSearch(
      String author, String song) async {
    List<LyricSearchResult> result =
        List<LyricSearchResult>.empty(growable: true);
    String searchXML = await _searchLyric(author, song);
    Map<String, dynamic> jsonResults = _convertToJson(searchXML);
    var jsonSearchResults = jsonResults[_lyricRoot][_lyricSearchResult];
    if (jsonSearchResults is! List) {
      return List<LyricSearchResult>.empty();
    }
    for (Map<String, dynamic> item in jsonSearchResults) {
      if (item.keys.contains(_lyricTitle) && item[_lyricTitle] != null) {
        logger.v(
            "simpleSearch found Lyric - title: ${item[_lyricTitle]} - Author: ${item[_lyricAuthor]} (Id: ${item[_lyricID]})");
        result.add(LyricSearchResult.fromJson(item));
      }
    }
    return Future.value(result);
  }

  // Parse XML and convert it to Json
  Map<String, dynamic> _convertToJson(String searchXML) {
    myTransformer.parse(searchXML);
    Map<String, dynamic> jsonResults =
        jsonDecode(myTransformer.toParkerWithAttrs());
    return jsonResults;
  }
}
