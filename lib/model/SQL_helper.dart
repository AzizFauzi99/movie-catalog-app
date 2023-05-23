import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movie_id INTEGER,
        user_id INTEGER REFERENCES users(id)
      )
      ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query('users');
  }

  // Future<List<Map<String, dynamic>>> getFavorites() async {
  //   Database db = await instance.database.query('favorites');
  //   return await db.query('favorites');
  // }
  Future<int> insertFavorite(int userId, int movieId) async {
    Database db = await instance.database;
    // return await db.insert('favorites', favorite);
    return await db.insert(
      'favorites',
      {
        'user_id': userId,
        'movie_id': movieId,
        // Kolom lain yang ingin Anda tambahkan
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    Database db = await instance.database;
    return await db.query('favorites');
  }

  Future<List<Map<String, dynamic>>> getFavoritesByUserId(int userId) async {
    Database db = await instance.database;
    return await db
        .query('favorites', columns: ['movie_id'], where: 'user_id = ?', whereArgs: [userId]);
  }
  
  Future<int> deleteFavorite(int userId, int movieId) async {
    Database db = await instance.database;
    return await db.delete('favorites', where: 'user_id = ? AND movie_id = ?', whereArgs: [userId, movieId]);
  }
  
  Future<int> getFavoritesByUserIdMovieId(int userId, int MovieId) async{
    Database db = await instance.database;
    return await db.query('favorites',where: 'user_id = ? AND movie_id = ?', whereArgs: [userId, MovieId]).then((value) => value.length);}

  Future<bool> checkFavorite(int userId, int movieId) async {
    Database db = await instance.database;
    var result = await db.query('favorites',
        where: 'user_id = ? AND movie_id = ?', whereArgs: [userId, movieId]);
    return result.isNotEmpty;
  }
}

