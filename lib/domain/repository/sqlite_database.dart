// SQLiteHelper.dart
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For native platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web
import 'package:flutter/foundation.dart'; // For kIsWeb check
import 'package:path/path.dart';

/// SQLite Helper for database connection
class SQLiteHelper {
  static final SQLiteHelper instance = SQLiteHelper._init();
  static Database? _database;

  SQLiteHelper._init();

  /// Conditional initialization based on platform
  Future<void> initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDatabase();
    _database = await _initDB('fitquest.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE runs (
        id TEXT PRIMARY KEY,
        distance REAL NOT NULL,
        duration INTEGER NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        route TEXT NOT NULL,
        userId TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}