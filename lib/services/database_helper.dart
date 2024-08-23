import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      version: 2,
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
      accountType TEXT NOT NULL,
      imageUrl TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )''';

    const contractTable = '''CREATE TABLE contract (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      contractDurationMonths INTEGER NOT NULL,
      createdAt TEXT NOT NULL,
      isValid INTEGER NOT NULL,
      isCompleted INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES user(id) ON DELETE CASCADE
    )''';

    const paymentTable = '''CREATE TABLE payment (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      contractId INTEGER NOT NULL,
      value INTEGER NOT NULL,
      paymentMethod TEXT NOT NULL,
      numberOfParcel INTEGER NOT NULL,
      dueDate TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      wasPaid INTEGER NOT NULL,
      FOREIGN KEY (contractId) REFERENCES contract(id) ON DELETE CASCADE
    )''';

    const muralsTable = '''CREATE TABLE murals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL,
      imageUrl TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      userId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES user(id) ON DELETE CASCADE
    )''';

    const treinoTable = '''CREATE TABLE treino (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      nome TEXT NOT NULL,
      qtdSeries INTEGER NOT NULL,
      qtdRepeticoes TEXT NOT NULL
    )''';

    const pacoteTable = '''CREATE TABLE pacote (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      nomePacote TEXT NOT NULL,
      letraDivisao TEXT NOT NULL,
      tipoTreino TEXT NOT NULL
    )''';

    const pacoteTreinoTable = '''CREATE TABLE pacote_treino (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      pacoteId INTEGER NOT NULL,
      treinoId INTEGER NOT NULL,
      FOREIGN KEY (pacoteId) REFERENCES pacote(id) ON DELETE CASCADE,
      FOREIGN KEY (treinoId) REFERENCES treino(id) ON DELETE CASCADE
    )''';

    const userPacoteTable = '''CREATE TABLE user_pacote (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      valido INTEGER NOT NULL,
      userTreinadorId INTEGER NOT NULL,
      userAlunoId INTEGER NOT NULL,
      FOREIGN KEY (userTreinadorId) REFERENCES user(id),
      FOREIGN KEY (userAlunoId) REFERENCES user(id)
    )''';

    const userPacoteTreinoTable = '''CREATE TABLE user_pacote_treino (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      userPacoteId INTEGER NOT NULL,
      pacoteTreinoId INTEGER NOT NULL,
      FOREIGN KEY (userPacoteId) REFERENCES user_pacote(id),
      FOREIGN KEY (pacoteTreinoId) REFERENCES pacote_treino(id)
    )''';

    const pesosTreinoTable = '''CREATE TABLE pesos_treino (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      treinoId INTEGER NOT NULL,
      peso INTEGER,
      userId INTEGER NOT NULL,
      FOREIGN KEY (treinoId) REFERENCES treino(id),
      FOREIGN KEY (userId) REFERENCES user(id)
    )''';

    const historicoTreinoTable = '''CREATE TABLE historico_treino (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL,
      tempoTreino TEXT NOT NULL,
      userPacoteTreinoId INTEGER NOT NULL,
      FOREIGN KEY (userPacoteTreinoId) REFERENCES user_pacote_treino(id)
    )''';

    await db.execute(userTable);
    await db.execute(contractTable);
    await db.execute(paymentTable);
    await db.execute(muralsTable);
    await db.execute(treinoTable);
    await db.execute(pacoteTable);
    await db.execute(pacoteTreinoTable);
    await db.execute(userPacoteTable);
    await db.execute(userPacoteTreinoTable);
    await db.execute(pesosTreinoTable);
    await db.execute(historicoTreinoTable);
  }
}
