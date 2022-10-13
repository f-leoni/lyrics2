class Lyric {
  int? id;
  String author;
  String title;
  String lyric;
  String imageUrl;
  String? checksum;
  String? album;
  String? lyricUrl;
  int? rank;
  String? correctUrl;

// Constructor
  Lyric({
    required this.id,
    required this.author,
    required this.title,
    required this.lyric,
    required this.imageUrl,
  });

// Create from json object
  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      id: json['LyricId'] as int,
      author: json['LyricArtist'] as String,
      title: json['LyricSong'] as String,
      lyric: json['Lyric'] as String,
      imageUrl: json['LyricCovertArtUrl'] as String,
    );
  }

// Copy
  Lyric copyWith(
      {int? id,
      String? author,
      String? title,
      String? imageUrl,
      String? lyric}) {
    return Lyric(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      lyric: lyric ?? this.lyric,
    );
  }

  static List<Lyric> samples = [
    Lyric(
        id: 1,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] 
  Walking across the sitting room 
  I turn the television off 
  Sitting beside you 

  Walking across the sitting room 
  I turn the television off 
  Sitting beside you 

  I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
    Lyric(
        id: 2,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
    Lyric(
        id: 3,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
    Lyric(
        id: 4,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
    Lyric(
        id: 5,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
    Lyric(
        id: 6,
        author: "Genesis",
        title: "Supper's Ready",
        lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
        imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg"),
  ];
}
