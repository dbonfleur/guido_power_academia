import '../models/treino_model/historico_treino.dart';
import '../services/database_helper.dart';

class HistoricoTreinoRepository {
  final DatabaseHelper databaseHelper;

  HistoricoTreinoRepository(this.databaseHelper);

  Future<int> createHistoricoTreino(HistoricoTreino historicoTreino) async {
    final db = await databaseHelper.database;
    return await db.insert('historico_treino', historicoTreino.toMap());
  }

  Future<List<HistoricoTreino>> getHistoricoTreinoByUserPacoteTreinoId(int userPacoteTreinoId) async {
    final db = await databaseHelper.database;
    final result = await db.query('historico_treino', where: 'userPacoteTreinoId = ?', whereArgs: [userPacoteTreinoId]);
    return result.map((e) => HistoricoTreino.fromMap(e)).toList();
  }

  Future<int> updateHistoricoTreino(HistoricoTreino historicoTreino) async {
    final db = await databaseHelper.database;
    return await db.update('historico_treino', historicoTreino.toMap(), where: 'id = ?', whereArgs: [historicoTreino.id]);
  }

  Future<int> deleteHistoricoTreino(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('historico_treino', where: 'id = ?', whereArgs: [id]);
  }
}
