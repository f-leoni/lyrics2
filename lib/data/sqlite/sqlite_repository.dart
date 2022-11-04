import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/components/logger.dart';
import 'package:lyrics_2/data/sqlite/database_helper.dart';
import 'package:lyrics_2/data/repository.dart';

class SQLiteRepository extends Repository with ChangeNotifier {
  //final List<Lyric> _currentLyrics = <Lyric>[];
  final dbHelper = DatabaseHelper.instance;
  //final _user = "";
  //final _darkTheme = false;
  //final _autoTheme = false;

  @override
  Future<List<Lyric>> findAllFavsLyrics() async {
    return await dbHelper.findAllLyrics();
  }

  @override
  Future<Lyric> findLyricById(int id) {
    return dbHelper.findLyricById(id);
  }

  @override
  Future<bool> isLyricFavoriteById(int id) {
    return dbHelper.isLyricFavoriteById(id);
  }

//List<Author> findAllAuthors();
  @override
  Future<int> insertLyricInFavs(Lyric lyric) async {
    bool alreadyInserted = await isLyricFavoriteById(lyric.lyricId);
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

  /*bool contains(Lyric lyric) {
    //TODO implement this method
    return false;
  }*/
}
