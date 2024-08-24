import '../models/treino_model/pacote.dart';
import '../services/database_helper.dart';

class PacoteRepository {
  final DatabaseHelper databaseHelper;

  PacoteRepository(this.databaseHelper);

  Future<int> createPacote(Pacote pacote) async {
    final db = await databaseHelper.database;
    return await db.insert('pacote', pacote.toMap());
  }

  Future<List<Pacote>> getAllPacotes() async {
    final db = await databaseHelper.database;
    final result = await db.query('pacote');
    return result.map((e) => Pacote.fromMap(e)).toList();
  }

  Future<int> updatePacote(Pacote pacote) async {
    final db = await databaseHelper.database;
    return await db.update('pacote', pacote.toMap(), where: 'id = ?', whereArgs: [pacote.id]);
  }

  Future<int> deletePacote(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('pacote', where: 'id = ?', whereArgs: [id]);
  }

  Future<Pacote> getPacoteById(int pacoteId) async {
    final db = await databaseHelper.database;
    final result = await db.query('pacote', where: 'id = ?', whereArgs: [pacoteId]);
    return Pacote.fromMap(result.first);
  }
}
