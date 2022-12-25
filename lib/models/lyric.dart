import 'package:lyrics2/models/lyric_data.dart';

class Lyric extends LyricData {
  int lyricId;
  String artist;
  String song;
  String lyric;
  String imageUrl;
  String checksum;
  String? album;
  String? lyricUrl;
  int? rank;
  String? correctUrl;
  bool isFavorite = false;
  String provider;

  String? owner;

// Constructor
  Lyric({
    required this.lyricId,
    required this.artist,
    required this.song,
    required this.lyric,
    required this.imageUrl,
    required this.checksum,
    required this.provider,
    this.owner,
  });

// Create from json object
  factory Lyric.fromJson(
      Map<String, dynamic> json, String owner, String provider) {
    String lyric = "";
    //String owner = "fraleoni@gmail.com";
    try {
      lyric = json['lyric'];
    } catch (e) {
      lyric = json['Lyric'];
    }

    return Lyric(
      //lyricId: int.parse(json['LyricId']),
      lyricId: int.parse(json['LyricId'].toString()),
      artist: json['LyricArtist'] as String,
      song: json['LyricSong'] as String,
      lyric: lyric,
      imageUrl: json['LyricCovertArtUrl'] as String,
      checksum: json['LyricChecksum'] as String,
      owner: owner,
      provider: provider,
    );
  }

  // Convert our Recipe to JSON to make it easier when you store
// it in the database
  Map<String, dynamic> toJson() => {
        'LyricId': lyricId,
        'LyricArtist': artist,
        'LyricSong': song,
        'LyricCovertArtUrl': imageUrl,
        'LyricChecksum': checksum,
        'lyric': lyric,
        'owner': owner,
        'provider': provider,
      };

// Copy
  Lyric copyWith(
      {int? pId,
      String? pAuthor,
      String? pTitle,
      String? pImageUrl,
      String? pLyric,
      String? pChecksum,
      String? pProvider}) {
    return Lyric(
        lyricId: pId ?? lyricId,
        artist: pAuthor ?? artist,
        song: pTitle ?? song,
        imageUrl: pImageUrl ?? imageUrl,
        lyric: pLyric ?? lyric,
        checksum: pChecksum ?? checksum,
        provider: pProvider ?? "");
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
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Lyric && other.lyricId == lyricId;
  }

  static get empty => Lyric(
      lyricId: -1,
      artist: "******* *******",
      song: "******* *******",
      lyric: "....",
      checksum: "error",
      imageUrl: "",
      provider: "");

  @override
  String getProxy() {
    return provider;
  }
}
