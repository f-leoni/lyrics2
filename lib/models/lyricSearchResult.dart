class LyricSearchResult {
  int lyricId;
  String artist;
  String song;
  String? songUrl;
  String? artistUrl;
  int? songRank;
  String lyricChecksum;

// Constructor
  LyricSearchResult({
    required this.lyricId,
    required this.artist,
    required this.song,
    required this.lyricChecksum,
  });

  @override
  String toString() {
    return "Titolo: ${this.song} - Autore: ${this.artist} (${this.lyricId})";
  }

// Create from json object
  factory LyricSearchResult.fromJson(Map<String, dynamic> json) {
    var cs;
    var lId;
    cs = json['LyricChecksum'];
    if (cs == null) {
      cs = "";
    }
    lId = json['LyricId'];
    return LyricSearchResult(
      lyricId: int.parse(lId),
      artist: json['Artist'] as String,
      song: json['Song'] as String,
      lyricChecksum: cs as String,
    );
  }

// Copy
  LyricSearchResult copyWith(
      {int? id,
      String? author,
      String? title,
      String? imageUrl,
      String? lyric}) {
    return LyricSearchResult(
      lyricId: id ?? this.lyricId,
      artist: author ?? this.artist,
      song: title ?? this.song,
      lyricChecksum: lyric ?? this.lyricChecksum,
    );
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
