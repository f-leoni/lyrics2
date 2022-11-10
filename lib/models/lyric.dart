import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrics_2/models/lyric_data.dart';

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

  String? owner;
  DocumentReference? reference;

// Constructor
  Lyric({
    required this.lyricId,
    required this.artist,
    required this.song,
    required this.lyric,
    required this.imageUrl,
    required this.checksum,
    //required this.isFavorite,
    this.reference,
    this.owner,
  });

// Create from json object
  factory Lyric.fromJson(Map<String, dynamic> json) {
    String lyric = "";
    String owner = "fraleoni@gmail.com";
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
      };

  factory Lyric.fromSnapshot(DocumentSnapshot snapshot) {
    final lyric = Lyric.fromJson(snapshot.data() as Map<String, dynamic>);
    lyric.reference = snapshot.reference;
    return lyric;
  }

// Copy
  Lyric copyWith(
      {int? pId,
      String? pAuthor,
      String? pTitle,
      String? pImageUrl,
      String? pLyric,
      String? pChecksum}) {
    return Lyric(
        lyricId: pId ?? lyricId,
        artist: pAuthor ?? artist,
        song: pTitle ?? song,
        imageUrl: pImageUrl ?? imageUrl,
        lyric: pLyric ?? lyric,
        checksum: pChecksum ?? checksum);
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
    return other is Lyric &&
        other.lyricId != null &&
        lyricId != null &&
        other.lyricId == lyricId;
  }

  static get empty => Lyric(
        lyricId: -1,
        artist: "error",
        song: "error",
        lyric: "error",
        checksum: "error",
        imageUrl: "",
      );
}
