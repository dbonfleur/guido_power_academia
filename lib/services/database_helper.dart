import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('guido_power_academia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      fullName TEXT NOT NULL,
      dateOfBirth TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      paymentMethod TEXT NOT NULL,
      contractDuration INTEGER NOT NULL,
      accountType TEXT NOT NULL,
      imageUrl TEXT
    )''';

    await db.execute(userTable);
  }

  Future<int> createUser(User user) async {
    final db = await instance.database;
    final id = await db.insert('user', user.toMap());
    return id;
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db.update(
      'user',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> getUser(String username, String password) async {
    final db = await instance.database;
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
    final db = await instance.database;
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
    final db = await instance.database;
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
