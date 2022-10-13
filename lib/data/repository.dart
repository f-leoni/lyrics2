import '../models/models.dart';

abstract class Repository {
  List<Lyric> findAllFavsLyrics();
  Lyric findLyricById(int id);
  //List<Author> findAllAuthors();
  int insertLyricInFavs(Lyric lyric);
  void deleteLyricFromFavs(Lyric lyric);
  Future init();
  void close();
}
