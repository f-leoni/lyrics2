import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lyrics2/lyricstheme.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/sqlite/database_helper.dart';

class SQLiteSettingsRepository with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  //TODO Change here for initial dark mode state
  var _darkMode = false;
  bool get darkMode => _darkMode;
  var _useGenius = true;
  bool get useGenius => _useGenius;
  Map<String, Setting>? _settings;
  set useGenius(bool value) {
    _useGenius = value;
    notifyListeners();
  }

  get getUser => null;
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  var _didSelectUser = false;
  get didSelectUser => _didSelectUser;

  ThemeData get themeData {
    if (_darkMode) return LyricsTheme.dark();
    return LyricsTheme.light();
  }

  TextTheme get textTheme {
    if (_darkMode) return LyricsTheme.darkTextTheme;
    return LyricsTheme.lightTextTheme;
  }

  void tapOnProfile(bool selected) {
    logger.d("Setting didSelectUser as ${selected.toString()}");
    _didSelectUser = selected;
    notifyListeners();
  }

  Future<void> insertSetting(Setting setting) {
    logger.d("SQLite - Inserting ${setting.value} in  ${setting.setting}");
    dbHelper.insertSetting(setting);
    _settings = null;
    notifyListeners();
    return Future.value(null);
  }

  Future<Setting?> getSetting(String name) {
    logger.d("SQLite - Getting setting $name");
    return dbHelper.findSettingByName(name);
  }

  Future<Map<String, Setting>> getSettings() async {
    logger.d("SQLite - Retrieving ALL settings");
    _settings ??= await dbHelper.getSettings();
    return Future.value(_settings);
  }

  Future<void> deleteSetting(String setting) {
    logger.d("SQLite - Deleting setting $setting");
    dbHelper.deleteSetting(setting);
    notifyListeners();
    return Future.value(null);
  }
}
