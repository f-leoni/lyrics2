import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/sqlite/database_helper.dart';

import '../lyricstheme.dart';

class SQLiteSettingsRepository with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  bool _isInitialized = false;

  late bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  late bool _darkerMode = false;
  bool get darkerMode => _darkerMode;
  set darkerMode(bool value) {
    _darkerMode = value;
    notifyListeners();
  }

  bool _useGenius = true;
  bool get useGenius => _useGenius;
  set useGenius(bool value) {
    _useGenius = value;
    notifyListeners();
  }

  bool _blackBackground = true;
  bool get blackBackground => _blackBackground;
  set blackBackground(bool value) {
    _blackBackground = value;
    notifyListeners();
  }

  final bool _didSelectUser = false;
  bool get didSelectUser => _didSelectUser;

  ThemeData get themeData {
    if (_darkMode) {
      if(_darkerMode) {
        return LyricsTheme.darker();
      }
      return LyricsTheme.dark();
    }
    return LyricsTheme.light();
  }

  TextTheme get textTheme {
    if (_darkMode) {
      if (_darkerMode) {
        return LyricsTheme.darkerTextTheme;
      }
      return LyricsTheme.darkTextTheme;
    }
    return LyricsTheme.lightTextTheme;
  }

  SQLiteSettingsRepository(){
    init();
  }

  Future<bool> init() async {
    if(_isInitialized) return _darkMode;
    Setting? dark = (await getSetting(Setting.darkTheme));
    Setting? darker = (await getSetting(Setting.darkerTheme));
    Setting? genius = (await getSetting(Setting.geniusProxy));
    _darkMode = dark==null?false:toBoolean(dark.value.toLowerCase());
    _darkerMode = darker==null?false:toBoolean(darker.value.toLowerCase());
    _useGenius = genius==null?false:toBoolean(genius.value.toLowerCase());
    _isInitialized=true;
    return _darkMode;
  }

  bool toBoolean(String str, [bool strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  Future<void> insertSetting(Setting setting) {
    logger.d("SQLite - Inserting ${setting.value} in  ${setting.setting}");
    dbHelper.insertSetting(setting);
    notifyListeners();

    return Future.value(null);
  }

  Future<Setting?> getSetting(String name) {
    logger.d("SQLite - Getting setting $name");
    return dbHelper.findSettingByName(name);
  }

  Future<Map<String, Setting>> getSettings() {
    logger.d("SQLite - Retrieving ALL settings");
    return dbHelper.getSettings();
  }

  Future<void> deleteSetting(String setting) {
    logger.d("SQLite - Deleting setting $setting");
    dbHelper.deleteSetting(setting);
    notifyListeners();
    return Future.value(null);
  }
}
