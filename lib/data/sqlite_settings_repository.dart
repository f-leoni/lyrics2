import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/data/sqlite/database_helper.dart';

class SQLiteSettingsRepository with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

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
