import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class FavoritesDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            overview TEXT
          )
        ''');
      },
    );
  }

  static Future<void> addFavorite(Movie movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Movie>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');

    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  static Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
