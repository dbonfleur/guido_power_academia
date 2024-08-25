import '../models/treino_model/pacote_treino.dart';
import '../services/database_helper.dart';

class PacoteTreinoRepository {
  final DatabaseHelper databaseHelper;

  PacoteTreinoRepository(this.databaseHelper);

  Future<void> createPacoteTreino(PacoteTreino pacoteTreino) async {
    final db = await databaseHelper.database;
    
    for (var treinoId in pacoteTreino.treinoIds) {
      await db.insert('pacote_treino', {
        'pacoteId': pacoteTreino.pacoteId,
        'treinoId': treinoId,
        'createdAt': pacoteTreino.createdAt.toIso8601String(),
        'updatedAt': pacoteTreino.updatedAt.toIso8601String(),
      });
    }
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

  Future<List<int>> getTreinoIdsByPacoteId(int pacoteId) async {
    final db = await databaseHelper.database;
    final result = await db.query('pacote_treino', where: 'pacoteId = ?', whereArgs: [pacoteId]);
    return result.map((e) => e['treinoId'] as int).toList();
  }
}
