import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';

// Mock lyrics service that grabs sample json data to mock lyrics request/response
class MockLyricsService {
  // Batch request that gets lyrics
  Future<ExploreData> getExploreData() async {
    final searchResults = await _getSearchResult();

    return ExploreData(
      searchResults,
      //    friendPosts
    );
  }

  // Get sample explore lyrics json to display in ui
  Future<List<Lyric>> _getSearchResult() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 300));
    // Load json from file system
    final dataString = await _loadAsset(
      'assets/sample_data/sample_lyrics_search_result.json',
    );
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each lyric and convert json to Lyric object.
    if (json['SearchLyricResult'] != null) {
      final lyrics = <Lyric>[];
      json['ArrayOfSearchLyricResult'].forEach((v) {
        lyrics.add(Lyric.fromJson(v));
      });
      return lyrics;
    } else {
      return [];
    }
  }

  // Get the sample lyric json to display in ui
  Future<List<Lyric>> getLyrics() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 300));
    // Load json from file system
    final dataString =
        await _loadAsset('assets/sample_data/sample_lyrics_search_result.json');
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each lyricResult and convert json to SearchResult object.
    if (json['ArrayOfSearchLyricResult'] != null) {
      final lyricsResults = <Lyric>[];
      json['SearchLyricResult'].forEach((v) {
        lyricsResults.add(Lyric.fromJson(v));
      });
      return lyricsResults;
    } else {
      return [];
    }
  }

  // Loads sample json data from file system
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}
