import 'package:lyrics_2/models/models.dart';

abstract class Repository {
  Future<List<Lyric>> findAllFavsLyrics();
  Future<Lyric> findLyricById(int id);
  //Future<List<Author>> findAllAuthors();
  Future<int> insertLyricInFavs(Lyric lyric);
  Future<void> deleteLyricFromFavs(Lyric lyric);
  Future<bool> isLyricFavoriteById(int id);
  Future init();
  void close();
}
