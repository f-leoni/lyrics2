import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:lyrics_2/components/logger.dart';
import 'package:lyrics_2/models/models.dart';
import 'repository.dart';

class MemoryRepository extends Repository with ChangeNotifier {
  final List<Lyric> _currentLyrics = <Lyric>[];
  //final _user = "";
  //final _darkTheme = false;
  //final _autoTheme = false;

  @override
  Future<List<Lyric>> findAllFavsLyrics(String? owner) {
    return Future.value(_currentLyrics);
  }

  @override
  Future<Lyric> findLyricById(int id, String? owner) {
    return Future.value(
        _currentLyrics.firstWhere((lyric) => lyric.lyricId == id));
  }

  @override
  Future<bool> isLyricFavoriteById(int id, String? owner) {
    try {
      _currentLyrics.firstWhere((lyric) => lyric.lyricId == id);
      return Future.value(true);
    } on StateError catch (e) {
      logger.e("Error '${e.message}' ID: $id");
      return Future.value(false);
    }
  }

//List<Author> findAllAuthors();
  @override
  Future<int> insertLyricInFavs(Lyric lyric) {
    if (!_currentLyrics.contains(lyric)) {
      _currentLyrics.add(lyric);
    } else {
      logger.v(
          "Lyric ${lyric.song} not added to favorites because it has already been added");
    }
    notifyListeners();
    return Future.value(0);
  }

  @override
  Future<void> deleteLyricFromFavs(Lyric lyric) {
    _currentLyrics.remove(lyric);
    notifyListeners();
    return Future.value(null);
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}

  @override
  Stream<Object?> getLyricStream() {
    // TODO: implement getLyricStream
    throw UnimplementedError();
  }
}
