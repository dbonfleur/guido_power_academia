import '../models/treino_model/pacote_treino.dart';
import '../services/database_helper.dart';

class PacoteTreinoRepository {
  final DatabaseHelper databaseHelper;

  PacoteTreinoRepository(this.databaseHelper);

  Future<int> createPacoteTreino(PacoteTreino pacoteTreino) async {
    final db = await databaseHelper.database;
    return await db.insert('pacote_treino', pacoteTreino.toMap());
  }

  Future<List<PacoteTreino>> getAllPacotesTreino() async {
    final db = await databaseHelper.database;
    final result = await db.query('pacote_treino');
    return result.map((e) => PacoteTreino.fromMap(e)).toList();
  }

  Future<int> updatePacoteTreino(PacoteTreino pacoteTreino) async {
    final db = await databaseHelper.database;
    return await db.update('pacote_treino', pacoteTreino.toMap(), where: 'id = ?', whereArgs: [pacoteTreino.id]);
  }

  Future<int> deletePacoteTreino(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('pacote_treino', where: 'id = ?', whereArgs: [id]);
  }
}
