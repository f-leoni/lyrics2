import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';

// Mock recipe service that grabs sample json data to mock recipe request/response
class MockLyricsService {
  // Batch request that gets both today recipes and friend's feed
  Future<ExploreData> getExploreData() async {
    final searchResults = await _getSearchResult();

    return ExploreData(
      searchResults,
      //    friendPosts
    );
  }

  // Get sample explore recipes json to display in ui
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
      final recipes = <Lyric>[];
      json['ArrayOfSearchLyricResult'].forEach((v) {
        recipes.add(Lyric.fromJson(v));
      });
      return recipes;
    } else {
      return [];
    }
  }

  // Get the sample recipe json to display in ui
  Future<List<Lyric>> getLyrics() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 300));
    // Load json from file system
    final dataString =
        await _loadAsset('assets/sample_data/sample_recipes.json');
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each recipe and convert json to SimpleRecipe object.
    if (json['recipes'] != null) {
      final recipes = <Lyric>[];
      json['recipes'].forEach((v) {
        recipes.add(Lyric.fromJson(v));
      });
      return recipes;
    } else {
      return [];
    }
  }

  // Loads sample json data from file system
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}
