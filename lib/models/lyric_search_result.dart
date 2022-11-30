import 'package:lyrics2/api/proxies.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/models/lyric_data.dart';

class LyricSearchResult extends LyricData {
  int lyricId;
  String artist;
  String song;
  String lyricChecksum;
  String provider;
  String? songUrl;
  String? artistUrl;
  int? songRank;
  bool isEmpty = false;

// Constructor
  LyricSearchResult({
    required this.lyricId,
    required this.artist,
    required this.song,
    required this.lyricChecksum,
    required this.provider,
    this.isEmpty = false,
  });

  @override
  String toString() {
    return "Titolo: $song - Autore: $artist ($lyricId)";
  }

  static get empty {
    return LyricSearchResult(
      lyricId: -1,
      artist: "",
      song: "",
      lyricChecksum: "",
      provider: "",
      isEmpty: true,
    );
  }

// Create from json object
  factory LyricSearchResult.fromJson(
      Map<String, dynamic> json, String provider) {
    String cs;
    String lId;
    try {
      if (json.keys.contains('LyricChecksum')) {
        cs = json['LyricChecksum'];
      } else {
        cs = "";
      }
      /*if (cs == null) {
      cs = "";
    }*/
      lId = json['LyricId'];

      return LyricSearchResult(
        lyricId: int.parse(lId),
        artist: json['Artist'] as String,
        song: json['Song'] as String,
        lyricChecksum: cs,
        provider: provider,
      );
    } on Exception catch (e) {
      logger.e("Error in converting to json ${e.toString()}");
      return LyricSearchResult.empty;
    }
  }

// Copy
  LyricSearchResult copyWith(
      {int? id,
      String? author,
      String? title,
      String? imageUrl,
      String? lyric,
      String? pProvider}) {
    return LyricSearchResult(
        lyricId: id ?? lyricId,
        artist: author ?? artist,
        song: title ?? song,
        lyricChecksum: lyric ?? lyricChecksum,
        provider: pProvider ?? provider);
  }

  // LyricData implementation
  @override
  int getId() {
    return lyricId;
  }

  @override
  String getSong() {
    return song;
  }

  @override
  String getArtist() {
    return artist;
  }

  @override
  String getProxy() {
    return provider;
  }

  static List<LyricSearchResult> samples = [
    LyricSearchResult(
      lyricId: 1,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test001",
      provider: Proxies.genius,
    ),
    LyricSearchResult(
      lyricId: 2,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test002",
      provider: Proxies.genius,
    ),
    LyricSearchResult(
      lyricId: 3,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test003",
      provider: Proxies.genius,
    ),
    LyricSearchResult(
      lyricId: 4,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test004",
      provider: Proxies.chartLyrics,
    ),
    LyricSearchResult(
      lyricId: 5,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test005",
      provider: Proxies.chartLyrics,
    ),
    LyricSearchResult(
      lyricId: 6,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test006",
      provider: Proxies.genius,
    )
  ];
}
