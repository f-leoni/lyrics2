import 'package:lyrics2/models/models.dart';

abstract class FavoritesRepository {
  Future<List<Lyric>> findAllFavsLyrics(String? owner);
  Stream<Object?> getLyricStream();
  Future<Lyric> findLyricById(int id, String? owner);
  //Future<List<Author>> findAllAuthors();
  Future<int> insertLyricInFavs(Lyric lyric);
  Future<void> deleteLyricFromFavs(Lyric lyric);
  Future<bool> isLyricFavoriteById(int id, String? owner);
  Future init();
  void close();
}
