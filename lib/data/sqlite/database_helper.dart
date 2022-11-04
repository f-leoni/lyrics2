import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:lyrics_2/models/models.dart';

class DatabaseHelper {
  static const _databaseName = 'lyrics.db';
  static const _databaseVersion = 1;
  static const lyricsTable = 'favorites';
  static const lyricsId = "LyricId";
  static const settingsTable = 'settings';
  static late BriteDatabase _streamDatabase;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static var lock = Lock();

  // only have a single app-wide reference to the database
  static Database? _database;

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE [$lyricsTable] (
      [$lyricsId] INTEGER  NOT NULL PRIMARY KEY,
      [LyricArtist] VARCHAR(100)  NOT NULL,
      [LyricSong] VARCHAR(150)  NOT NULL,
      [lyric] TEXT  NOT NULL,
      [LyricCovertArtUrl] VARCHAR(255) NOT NULL,
      [LyricChecksum] VARCHAR(32)  UNIQUE NOT NULL,
      [album] VARCHAR(150) NULL,
      [lyric_url] VARCHAR(255) NULL,
      [rank] INTEGER  NULL,
      [correct_url] VARCHAR(255)  NULL
      )''');

    await db.execute(''' 
    CREATE TABLE [$settingsTable] (
      [id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      [setting] varCHAR(20)  UNIQUE NOT NULL,
      [value] varchar(255)  NULL
      )''');
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Remember to turn off debugging before deploying app to store(s).
    Sqflite.setDebugModeOn(true);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data
    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is accessed
      if (_database == null) {
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Lyric> parseLyrics(List<Map<String, dynamic>> lyricsList) {
    final lyrics = <Lyric>[];
    lyricsList.forEach((lyricsMap) {
      final lyric = Lyric.fromJson(lyricsMap);
      lyrics.add(lyric);
    });
    return lyrics;
  }

  Future<List<Lyric>> findAllLyrics() async {
    final db = await instance.streamDatabase;
    final lyricsList = await db.query(lyricsTable);
    final lyrics = parseLyrics(lyricsList);
    return lyrics;
  }

  Stream<List<Lyric>> watchAllLyrics() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(lyricsTable).mapToList((row) => Lyric.fromJson(row));
  }

  Future<Lyric> findLyricById(int id) async {
    final db = await instance.streamDatabase;
    final lyricsList = await db.query(lyricsTable, where: 'id = $id');
    final lyrics = parseLyrics(lyricsList);
    return lyrics.first;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertLyric(Lyric lyric) {
    return insert(lyricsTable, lyric.toJson());
  }

  Future<int> _delete(String table, String columnId, int id) async {
    final db = await instance.streamDatabase;
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteLyric(Lyric lyric) async {
    return _delete(lyricsTable, lyricsId, lyric.lyricId);
  }

  Future<bool> isLyricFavoriteById(int id) async {
    final db = await instance.streamDatabase;
    var result = await db.query(lyricsTable, where: "$lyricsId==$id", limit: 1);
    if (result.length < 1)
      return Future.value(false);
    else
      return Future.value(true);
  }

  void close() {
    _streamDatabase.close();
  }
}
