import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:lyrics_2/components/logger.dart';
import 'repository.dart';
import '../models/models.dart';

class MemoryRepository extends Repository with ChangeNotifier {
  final List<Lyric> _currentLyrics = <Lyric>[];
  //final _user = "";
  //final _darkTheme = false;
  //final _autoTheme = false;

  @override
  List<Lyric> findAllFavsLyrics() {
    return _currentLyrics;
  }

  @override
  Lyric findLyricById(int? id) {
    return _currentLyrics.firstWhere((lyric) => lyric.lyricId == id);
  }

  @override
  bool isLyricFavoriteById(int? id) {
    try {
      _currentLyrics.firstWhere((lyric) => lyric.lyricId == id);
      return true;
    } on StateError catch (e) {
      logger.e("Error ${e.message}");
      return false;
    }
  }

//List<Author> findAllAuthors();
  @override
  int insertLyricInFavs(Lyric? lyric) {
    if (lyric != null && !_currentLyrics.contains(lyric)) {
      _currentLyrics.add(lyric);
    } else {
      logger
          .i("Lyric ${lyric!.song} not added favorites because already added");
    }
    notifyListeners();
    return 0;
  }

  @override
  void deleteLyricFromFavs(Lyric? lyric) {
    if (lyric != null) {
      _currentLyrics.remove(lyric);
      notifyListeners();
    }
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}

  bool contains(Lyric lyric) {
    return _currentLyrics.contains(lyric);
  }
}
