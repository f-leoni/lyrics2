import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrics_2/models/lyric.dart';
import 'package:lyrics_2/components/logger.dart';
import 'package:lyrics_2/models/models.dart';
import 'repository.dart';

class FirebaseRepository extends Repository with ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('lyrics');

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
    logger.i("Deleting [${lyric.lyricId}]...");
    await collection
        .where('LyricId', isEqualTo: lyric.lyricId)
        .get()
        .then((value) {
      logger.i("Found [${lyric.lyricId}]...");
      value.docs.forEach((element) {
        collection.doc(element.id).delete().then((value) {
          logger.i("Success!");
        }).catchError((error) {
          logger.i("Couldn't delete Lyric [${lyric.song}]. Error: $error");
        });
      });
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
      var docs = await querySnapshot.docs;
      docs.forEach((doc) async {
        Lyric currLyric = await Lyric.fromSnapshot(doc);
        lyricsList.add(currLyric);
        logger.i("Found favorite: ${currLyric.song}");
      });
    }).onError((error, stackTrace) {
      logger.e("Error in retrieving Favorites: $error");
      throw Exception(error);
    });
    return Future.value(lyricsList);
  }

  @override
  Future<Lyric> findLyricById(int lyricId, String? owner) async {
    List<Lyric> lyricsList = List<Lyric>.empty(growable: true);
    await collection
        .where('owner', isEqualTo: owner)
        .where('LyricId', isEqualTo: lyricId)
        .get()
        .then((QuerySnapshot snapshot) async {
      var docs = await snapshot.docs;
      docs.forEach((doc) async {
        Lyric currLyric = await Lyric.fromSnapshot(doc);
        lyricsList.add(currLyric);
        logger.i("Found favorite by ID: ${currLyric.song}");
      });
    }).onError((error, stackTrace) {
      logger.e("Error in retrieving Favorites by id: $error");
      return Future.value(Lyric.empty);
    });
    if (lyricsList.length > 0) {
      return Future.value(lyricsList.first);
    } else {
      return Future.value(Lyric.empty);
    }
  }

  @override
  Future<bool> isLyricFavoriteById(int lyricId, String? owner) async {
    bool isFavorite = false;
    try {
      var lyric = await collection
          .where('owner', isEqualTo: owner)
          .where('LyricId', isEqualTo: lyricId)
          .get();
      return (lyric.size > 0);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
