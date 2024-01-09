import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../sign_up.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper instance = LocalDatabaseHelper._();

  static Database? _database;

  LocalDatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'client_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE `user` (`code` INTEGER, `nom` TEXT, `tel` INTEGER, `email` TEXT, `adresse` TEXT)',
        );
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> fetchUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(
      maps.length,
          (i) => User(
        code: maps[i]['code'] as int,
        nom: maps[i]['nom'] as String,
        tel: maps[i]['tel'] as int,
        email: maps[i]['email'] as String,
        adresse: maps[i]['adresse'] as String,
      ),
    );
  }
}
