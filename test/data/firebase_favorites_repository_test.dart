import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:lyrics2/data/firebase_favorites_repository.dart';
import 'package:lyrics2/models/lyric.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final instance = FakeFirebaseFirestore();
  CollectionReference<Map<String, dynamic>> lyricsCollection =
      instance.collection('lyrics');

  var favorites = FirebaseFavoritesRepository(lyricsCollection);

  group('Testing App Provider ', () {
    int testID = 75689468958;
    String testOwner = "testuser@test.com";

    test('A new item should be added', () async {
      var lyric = Lyric.empty;
      lyric.owner = testOwner;
      lyric.lyricId = testID;
      favorites.insertLyricInFavs(lyric);
      expect(await favorites.isLyricFavoriteById(testID, testOwner), true);
    });

    test('An item should be removed', () async {
      var lyric = Lyric.empty;
      lyric.owner = testOwner;
      lyric.lyricId = testID;
      favorites.deleteLyricFromFavs(lyric);
      expect(await favorites.isLyricFavoriteById(testID, testOwner), false);
    });
  });
}
