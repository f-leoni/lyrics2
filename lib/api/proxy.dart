import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/models/lyric_search_result.dart';

abstract class Proxy {
  Future<Lyric> getLyric(LyricSearchResult lyric);
  Future<List<LyricSearchResult>> simpleSearchText(String song);
  Future<List<LyricSearchResult>> simpleSearch(String author, String song);
  String getIconPath();
}
