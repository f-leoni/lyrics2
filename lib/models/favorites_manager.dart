import 'package:flutter/material.dart';
import 'package:lyrics_2/models/lyric.dart';

class FavoritesManager extends ChangeNotifier {
  final _favoriteItems = <Lyric>[];
  int _selectedIndex = -1;
  bool _createNewItem = false;

  List<Lyric> get favoriteItems => List.unmodifiable(_favoriteItems);
  int get selectedIndex => _selectedIndex;
  Lyric? get selectedGroceryItem =>
      _selectedIndex != -1 ? _favoriteItems[_selectedIndex] : null;
  bool get isCreatingNewItem => _createNewItem;

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void deleteItem(int index) {
    _favoriteItems.removeAt(index);
    notifyListeners();
  }

  void groceryItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void addItem(Lyric item) {
    _favoriteItems.add(item);
    _createNewItem = false;
    notifyListeners();
  }

  void updateItem(Lyric item, int index) {
    _favoriteItems[index] = item;
    _selectedIndex = -1;
    _createNewItem = false;
    notifyListeners();
  }

  void completeItem(int index, bool change) {
    final item = _favoriteItems[index];
    _favoriteItems[index] = item.copyWith();
    notifyListeners();
  }
}
