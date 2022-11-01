import 'package:lyrics_2/components/logger.dart';
import 'package:lyrics_2/models/lyric_data.dart';
import 'package:lyrics_2/models/lyric_search_result.dart';

class LyricSearchResult extends LyricData {
  int lyricId;
  String artist;
  String song;
  String? songUrl;
  String? artistUrl;
  int? songRank;
  String lyricChecksum;
  bool isEmpty = false;

// Constructor
  LyricSearchResult({
    required this.lyricId,
    required this.artist,
    required this.song,
    required this.lyricChecksum,
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
      isEmpty: true,
    );
  }

// Create from json object
  factory LyricSearchResult.fromJson(Map<String, dynamic> json) {
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
      );
    } on Exception catch (e) {
      logger.e("Error in converting to json");
      return LyricSearchResult.empty;
    }
  }

// Copy
  LyricSearchResult copyWith(
      {int? id,
      String? author,
      String? title,
      String? imageUrl,
      String? lyric}) {
    return LyricSearchResult(
      lyricId: id ?? lyricId,
      artist: author ?? artist,
      song: title ?? song,
      lyricChecksum: lyric ?? lyricChecksum,
    );
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

  static List<LyricSearchResult> samples = [
    LyricSearchResult(
        lyricId: 1,
        artist: "Genesis",
        song: "Supper's Ready",
        lyricChecksum: "test001"),
    LyricSearchResult(
        lyricId: 2,
        artist: "Genesis",
        song: "Supper's Ready",
        lyricChecksum: "test002"),
    LyricSearchResult(
        lyricId: 3,
        artist: "Genesis",
        song: "Supper's Ready",
        lyricChecksum: "test003"),
    LyricSearchResult(
        lyricId: 4,
        artist: "Genesis",
        song: "Supper's Ready",
        lyricChecksum: "test004"),
    LyricSearchResult(
      lyricId: 5,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test005",
    ),
    LyricSearchResult(
      lyricId: 6,
      artist: "Genesis",
      song: "Supper's Ready",
      lyricChecksum: "test006",
    )
  ];
}
