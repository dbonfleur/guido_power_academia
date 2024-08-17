import '../models/user_model.dart';
import '../services/database_helper.dart';

class UserRepository {
  final DatabaseHelper databaseHelper;

  UserRepository(this.databaseHelper);

  Future<int> createUser(User user) async {
    final db = await databaseHelper.database;
    final id = await db.insert('user', user.toMap());
    return id;
  }

  Future<int> updateUser(User user) async {
    final db = await databaseHelper.database;
    return db.update(
      'user',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> getAuth(String username, String password) async {
    final db = await databaseHelper.database;
    final hashedPassword = User.hashPassword(password);
    final maps = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) => User.fromMap(map)).first;
    } else {
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) => User.fromMap(map)).first;
    } else {
      return null;
    }
  }

  Future<List> getUsersByName(String name) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      where: 'fullName LIKE ? AND accountType = ?',
      whereArgs: ['%$name%', 'aluno'],
    );

    return maps.isNotEmpty
        ? maps.map((map) => User.fromMap(map)).toList()
        : <User>[];
  }

  Future<User?> getUserById(int id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) => User.fromMap(map)).first;
    } else {
      return null;
    }
  }

  Future<List> getUsersByAccountType(String accountType) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      where: 'accountType = ?',
      whereArgs: [accountType],
    );

    return maps.isNotEmpty
        ? maps.map((map) => User.fromMap(map)).toList()
        : <User>[];
  }

  Future <List> getUsersByFullName(String fullName) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      where: 'fullName LIKE ?',
      whereArgs: ['%$fullName%'],
    );

    return maps.isNotEmpty
        ? maps.map((map) => User.fromMap(map)).toList()
        : <User>[];
  }
}
