import '../models/user_model.dart';
import '../services/database_helper.dart';

class UserRepository {
  final DatabaseHelper databaseHelper;

  UserRepository(this.databaseHelper);

  // Future<void> createUser(User user) async {
  //   await databaseHelper.createUser(user);
  // }

  // Future<void> updateUser(User user) async {
  //   await databaseHelper.updateUser(user);
  // }

  // Future<User?> authenticate(String username, String password) async {
  //   return await databaseHelper.getUser(username, password);
  // }

  // Future<User?> getUserByUsername(String username) async {
  //   return await databaseHelper.getUserByUsername(username);
  // }

  // Future<User?> getUserById(int userId) async {
  //   return await databaseHelper.getUserById(userId);  
  // }

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
      columns: [
        'id',
        'username',
        'fullName',
        'dateOfBirth',
        'email',
        'password',
        'paymentMethod',
        'contractDuration',
        'accountType',
        'imageUrl'
      ],
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'] as int?,
        username: maps.first['username'] as String,
        fullName: maps.first['fullName'] as String,
        dateOfBirth: maps.first['dateOfBirth'] as String,
        email: maps.first['email'] as String,
        password: maps.first['password'] as String,
        paymentMethod: maps.first['paymentMethod'] as String,
        contractDuration: maps.first['contractDuration'] as int,
        accountType: maps.first['accountType'] as String,
        imageUrl: maps.first['imageUrl'] as String?,
      );
    } else {
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      columns: [
        'id',
        'username',
        'fullName',
        'dateOfBirth',
        'email',
        'password',
        'paymentMethod',
        'contractDuration',
        'accountType',
        'imageUrl'
      ],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'] as int?,
        username: maps.first['username'] as String,
        fullName: maps.first['fullName'] as String,
        dateOfBirth: maps.first['dateOfBirth'] as String,
        email: maps.first['email'] as String,
        password: maps.first['password'] as String,
        paymentMethod: maps.first['paymentMethod'] as String,
        contractDuration: maps.first['contractDuration'] as int,
        accountType: maps.first['accountType'] as String,
        imageUrl: maps.first['imageUrl'] as String?,
      );
    } else {
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'user',
      columns: [
        'id',
        'username',
        'fullName',
        'dateOfBirth',
        'email',
        'password',
        'paymentMethod',
        'contractDuration',
        'accountType',
        'imageUrl'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'] as int?,
        username: maps.first['username'] as String,
        fullName: maps.first['fullName'] as String,
        dateOfBirth: maps.first['dateOfBirth'] as String,
        email: maps.first['email'] as String,
        password: maps.first['password'] as String,
        paymentMethod: maps.first['paymentMethod'] as String,
        contractDuration: maps.first['contractDuration'] as int,
        accountType: maps.first['accountType'] as String,
        imageUrl: maps.first['imageUrl'] as String?,
      );
    } else {
      return null;
    }
  }
}
