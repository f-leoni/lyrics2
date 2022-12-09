import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/models/lyric.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var favorites = FirebaseFavoritesRepository();

  group('Testing App Provider ', () {
    int testID = 75689468958;
    String testOwner = "testuser@test.com";

    test('A new item should be added', () {
      var lyric = Lyric.empty();
      lyric.owner = testOwner;
      lyric.id = testID;
      favorites.insertLyricInFavs(lyric);
      expect(favorites.isLyricFavoriteById(testID, testOwner), true);
    });

    test('An item should be removed', () {
      var lyric = Lyric.empty();
      lyric.owner = testOwner;
      lyric.id = testID;

      favorites.deleteLyricFromFavs(lyric);
      expect(favorites.isLyricFavoriteById(testID, testOwner), false);
    });
  });
}
