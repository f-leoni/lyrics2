import 'package:http/http.dart' as http;
import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/models/lyric_search_result.dart';

abstract class Proxy {
  //Future<http.Response> _getFutureResponse(String uri);
  //Future<String> _searchLyricText(String text);
  //Map<String, dynamic> _convertToJson(String searchXML);
  Future<Lyric> getLyric(LyricSearchResult lyric);
  Future<List<LyricSearchResult>> simpleSearchText(String song);
  Future<List<LyricSearchResult>> simpleSearch(String author, String song);
}
