import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lyrics2/lyricstheme.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/sqlite/database_helper.dart';

class SQLiteSettingsRepository with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  late bool _darkMode;// = false;
  late bool _darkerMode;// = false;
  bool _isInitialized = false;
  bool _useGenius = true;
  bool _didSelectUser = false;

  bool get darkMode => _darkMode;
  bool get darkerMode => _darkerMode;
  bool get useGenius => _useGenius;
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

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
  set darkerMode(bool value) {
    _darkerMode = value;
    notifyListeners();
  }
  set useGenius(bool value) {
    _useGenius = value;
    notifyListeners();
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

  void tapOnProfile(bool selected) {
    logger.d("Setting didSelectUser as ${selected.toString()}");
    _didSelectUser = selected;
    notifyListeners();
  }

  Future<void> insertSetting(Setting setting) {
    logger.d("SQLite - Inserting ${setting.value} in  ${setting.setting}");
    dbHelper.insertSetting(setting);
    //_settings = null;
    notifyListeners();
    return Future.value(null);
  }

  Future<Setting?> getSetting(String name) {
    logger.d("SQLite - Getting setting $name");
    return dbHelper.findSettingByName(name);
  }

  Future<Map<String, Setting>> getSettings() async {
    logger.d("SQLite - Retrieving ALL settings");
    /*_settings ??= await dbHelper.getSettings();
    return Future.value(_settings);*/
    return dbHelper.getSettings();
  }

  Future<void> deleteSetting(String setting) {
    logger.d("SQLite - Deleting setting $setting");
    dbHelper.deleteSetting(setting);
    notifyListeners();
    return Future.value(null);
  }
}
