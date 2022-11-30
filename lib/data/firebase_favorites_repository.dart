import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrics2/models/lyric.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/models/models.dart';
import 'favorites_repository.dart';

class FirebaseFavoritesRepository extends FavoritesRepository
    with ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('lyrics');

  @override
  Stream<QuerySnapshot> getLyricStream() {
    return collection.snapshots();
  }

  @override
  Future<int> insertLyricInFavs(Lyric lyric) {
    collection.add(lyric.toJson());
    notifyListeners();
    return Future.value(0);
  }

  @override
  Future<void> deleteLyricFromFavs(Lyric lyric) async {
    logger.d("Deleting form Firebase ${lyric.song}[${lyric.lyricId}]...");
    await collection
        .where('LyricId', isEqualTo: lyric.lyricId)
        .get()
        .then((value) {
      logger.d("  Found [${lyric.lyricId}]...");
      for (var element in value.docs) {
        collection.doc(element.id).delete().then((value) {
          logger.d("  Delete completed!");
        }).catchError((error) {
          logger.i(
              "Couldn't delete Lyric ${lyric.song}[${lyric.lyricId}]. Error: $error");
        });
      }
    });
    notifyListeners();
    return Future.value(null);
  }

  @override
  Future<List<Lyric>> findAllFavsLyrics(String? owner) async {
    List<Lyric> lyricsList = List<Lyric>.empty(growable: true);

    await collection
        .where('owner', isEqualTo: owner)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      var docs = querySnapshot.docs;
      for (var doc in docs) {
        Lyric currLyric = Lyric.fromSnapshot(doc, owner!);
        lyricsList.add(currLyric);
        //logger.v("Found favorite: ${currLyric.song}");
      }
    }).onError((error, stackTrace) {
      logger.e("Error in retrieving Favorites: $error");
      throw Exception(error);
    });
    return Future.value(lyricsList);
  }

  @override
  Future<Lyric> findLyricById(int id, String? owner) async {
    List<Lyric> lyricsList = List<Lyric>.empty(growable: true);
    await collection
        .where('owner', isEqualTo: owner)
        .where('LyricId', isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) async {
      var docs = snapshot.docs;
      for (var doc in docs) {
        Lyric currLyric = Lyric.fromSnapshot(doc, owner!);
        lyricsList.add(currLyric);
        logger.i("Found favorite by ID: ${currLyric.song}");
      }
    }).onError((error, stackTrace) {
      logger.e("Error in retrieving Favorites by id: $error");
      return Future.value(Lyric.empty);
    });
    if (lyricsList.isNotEmpty) {
      return Future.value(lyricsList.first);
    } else {
      return Future.value(Lyric.empty);
    }
  }

  @override
  Future<bool> isLyricFavoriteById(int id, String? owner) async {
    //bool isFavorite = false;
    try {
      var lyric = await collection
          .where('owner', isEqualTo: owner)
          .where('LyricId', isEqualTo: id)
          .get();
      return (lyric.size > 0);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
