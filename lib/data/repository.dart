import '../models/models.dart';

abstract class Repository {
  List<Lyric> findAllFavsLyrics();
  Lyric findLyricById(int id);
  //List<Author> findAllAuthors();
  int insertLyricInFavs(Lyric lyric);
  void deleteLyricFromFavs(Lyric lyric);
  bool isLyricFavoriteById(int? id);
  Future init();
  void close();
}
