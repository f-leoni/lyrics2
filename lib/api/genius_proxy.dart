library lyrics_library;

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:lyrics2/api/proxy.dart';
import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/models/lyric_exception.dart';
import 'package:lyrics2/models/lyric_search_result.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/api/proxies.dart';
import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:lyrics2/env.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class GeniusProxy extends Proxy {
  GeniusApiRaw geniusApi = GeniusApiRaw(
    accessToken: Env.geniusToken,
// Set all methods to return plain text instead of the default dom format.
    defaultOptions:
        const GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
  );

  geniusProxy() {}

  // PRIVATE METHODS
  Future<dynamic> _getSong(id) async {
    final res = await geniusApi.getSong(id);
    return res.data!['song'];
  }

  // Convert Genius result to LyricSearchResult
  Future<LyricSearchResult> _resultToLSR(result) async {
    var resValue = result['result'];
    var tempLyric = LyricSearchResult(
      artist: resValue["artist_names"],
      lyricId: resValue["id"],
      song: resValue["title"],
      lyricChecksum: resValue["url"],
      provider: Proxies.genius,
    );
    return tempLyric;
  }

  // Convert Genius result to LyricSearchResult
  Future<Lyric> _songToLyric(result) async {
    var tempLyric = Lyric(
      artist: result["artist_names"],
      lyricId: result["id"],
      song: result["title"],
      checksum: result["url"],
      imageUrl: result["header_image_url"],
      owner: "",
      provider: Proxies.genius,
      lyric: await _scrape(result["url"]),
    );
    return Future.value(tempLyric);
  }

  Future<dynamic> _getSearch(String query, GeniusApiOptions? options) async {
    if (options == null) {
      final res = await geniusApi.getSearch(query);
      return _getResults(res.data!['hits']);
    }
    //final res = await geniusApi.getSearch(query, options: options);
    final res = await geniusApi.getSearch(query, options: options);
    return _getResults(res.data!['hits']);
  }

  Future<String> _scrape(String url) async {
    final uri = Uri.parse(url);
    String body = "";
    try {
      body = await http.read(uri).onError((error, stackTrace) {
        logger.e("Error: $error\n$stackTrace");
        throw LyricException(500, error.toString());
      });
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    BeautifulSoup bs = BeautifulSoup(body);
    String outLyric = bs
        .find('*', id: 'lyrics-root')!
        .children[2]
        .innerHtml
        .replaceAll("<br>", "\n");
    return _parseHtmlString(outLyric);
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return parsedString;
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
  @override
  Future<List<LyricSearchResult>> simpleSearchText(String song) async {
    final queryResult = await _getSearch(song, null);
    return queryResult;
  }

  @override
  Future<List<LyricSearchResult>> simpleSearch(
      String author, String song) async {
    final queryResult = await _getSearch("$author $song", null);
    return queryResult;
  }

  @override
  Future<Lyric> getLyric(LyricSearchResult lyric) async {
    final result = await _getSong(lyric.lyricId).onError((error, stackTrace) {
      logger.e("Error: $error\n$stackTrace");
    });
    return _songToLyric(result);
  }
}
