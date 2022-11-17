library lyrics_library;

import 'package:lyrics2/api/proxy.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/models/lyric_search_result.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:lyrics2/env.dart';
import 'package:provider/provider.dart';

class GeniusProxy extends Proxy {
  GeniusApiRaw geniusApi = GeniusApiRaw(
    accessToken: Env.geniusToken,
// Set all methods to return plain text instead of the default dom format.
    defaultOptions:
        const GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
  );

  geniusProxy() {}

  // PRIVATE METHODS
  Future<dynamic> _getFullSearch(query) async {
    final res = await geniusApi.getSearch(query);
    var x = _getResults(res.data!['hits']);
    return x; // Outp
  }

  Future<dynamic> _getSong(id) async {
    // Get info about song "https://genius.com/Yxngxr1-riley-reid-lyrics".
    final res = await geniusApi.getSong(id);
    return res.data!['song'];
  }

  Future<LyricSearchResult> _resultToLSR(result) async {
    //"https://genius.com/Polo-g-broken-guitars-lyrics"
    var resValue = result['result'];
    var x = await _scrape(resValue['url'], resValue['path']);
    //print("${resValue['title']}\n");
    var tempLyric = LyricSearchResult(
      artist: resValue["artist_names"],
      lyricId: resValue["id"],
      song: resValue["title"],
      lyricChecksum: resValue["url"],
    );
    return tempLyric;
  }

  Future<Lyric> _resultToLyric(result) async {
    //var resValue = result['result'];
    //print("${resValue['title']}\n");
    var tempLyric = Lyric(
        artist: result["artist_names"],
        lyricId: result["id"],
        song: result["title"],
        checksum: result["url"],
        imageUrl: result["header_image_url"],
        owner: _getOwner(),
        lyric: await _scrape(
          result["url"],
          result["path"],
        ));
    return Future.value(tempLyric);
  }

  Future<dynamic> _getSearch(String query) async {
    final res = await geniusApi.getSearch(query);
    return _getResults(res.data!['hits']);
  }

  //TODO to be implemented
  Future<String> _scrape(String url, String path) {
    return Future.value("To be implemented");
  }

  //TODO to be implemented
  String _getOwner() {
    String owner = "";
    //owner = Provider.of<FirebaseUserRepository>(context,listen: false).getUser.email;
    return owner;
  }

  Future<List<LyricSearchResult>> _getResults(List<dynamic> results) async {
    List<LyricSearchResult> out = List<LyricSearchResult>.empty(growable: true);
    for (var result in results) {
      LyricSearchResult tempLyric = await _resultToLSR(result);
      out.add(tempLyric);
    }
    return out;
  }

  // PROXY IMPLEMENTATION
  //TODO to be implemented
  @override
  Future<List<LyricSearchResult>> simpleSearchText(String query) async {
    final queryResult = await _getSearch(query);
    return queryResult;
  }

  //TODO to be implemented
  @override
  Future<Lyric> getLyric(LyricSearchResult lyric) async {
    final result = await _getSong(lyric.lyricId).onError((error, stackTrace) {
      logger.e("Error: $error\n$stackTrace");
    });
    var x = 1;
    final out = _resultToLyric(result);
    return out;
  }

  //TODO to be implemented
  @override
  Future<List<LyricSearchResult>> simpleSearch(
      String author, String song) async {
    //var result =
    return Future<List<LyricSearchResult>>.value([]);
  }
}
