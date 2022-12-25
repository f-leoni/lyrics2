import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/favorites_repository.dart';
import 'package:lyrics2/data/sqlite/database_helper.dart';
import 'package:lyrics2/models/lyric.dart';

class SQLiteFavoritesRepository extends FavoritesRepository
    with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertFavorite(Lyric lyric) {
    return Future.value(null);
  }

  @override
  Future<List<Lyric>> findAllFavsLyrics(String? owner) {
    return dbHelper.findAllLyrics();
  }

  @override
  Future<Lyric> findLyricById(int id, String? owner) {
    return dbHelper.findLyricById(id);
  }

  @override
  Future<bool> isLyricFavoriteById(int id, String? owner) async {
    return dbHelper.isLyricFavoriteById(id);
  }

//List<Author> findAllAuthors();
  @override
  Future<int> insertLyricInFavs(Lyric lyric) async {
    bool alreadyInserted = await isLyricFavoriteById(lyric.lyricId, "");
    if (!alreadyInserted) {
      final id = await dbHelper.insertLyric(lyric);
      logger.d("Lyric ${lyric.song} with id = $id has been added to favorites");
    } else {
      logger.v(
          "Lyric ${lyric.song} not added to favorites because already added");
    }
    notifyListeners();
    return 0;
  }

  @override
  Future<void> deleteLyricFromFavs(Lyric lyric) {
    dbHelper.deleteLyric(lyric);
    notifyListeners();

    return Future.value(null);
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }

  @override
  Stream<Object?> getLyricStream() {
    // TODO: implement getLyricStream
    throw UnimplementedError();
  }
}
