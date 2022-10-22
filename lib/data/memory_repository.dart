import 'dart:core';
import 'package:flutter/foundation.dart';
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
  Lyric findLyricById(int id) {
    return _currentLyrics.firstWhere((lyric) => lyric.id == id);
  }

//List<Author> findAllAuthors();
  @override
  int insertLyricInFavs(Lyric lyric) {
    _currentLyrics.add(lyric);

    notifyListeners();
    return 0;
  }

  @override
  void deleteLyricFromFavs(Lyric lyric) {
    _currentLyrics.remove(lyric);

    notifyListeners();
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
