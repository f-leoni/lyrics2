library lyrics_library;

import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/api/proxy.dart';
import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/models/lyric_search_result.dart';
import 'package:lyrics2/env.dart';
import 'package:provider/provider.dart';

class GeniusProxyAlternative extends Proxy {
  //Genius genius = Genius(accessToken: Env.geniusToken);

  @override
  Future<Lyric> getLyric(LyricSearchResult lyric) {
    // TODO: implement getLyric
    throw UnimplementedError();
  }

  @override
  Future<List<LyricSearchResult>> simpleSearch(
      String author, String song) async {
    //Song? mySong = (await genius.searchSong(artist: author, title: song));

    // TODO: implement simpleSearch
    throw UnimplementedError();
  }

  @override
  Future<List<LyricSearchResult>> simpleSearchText(String song) {
    // TODO: implement simpleSearchText
    throw UnimplementedError();
  }
}
