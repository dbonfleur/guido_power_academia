import '../models/treino_model/peso_treino.dart';
import '../services/database_helper.dart';

class PesosTreinoRepository {
  final DatabaseHelper databaseHelper;

  PesosTreinoRepository(this.databaseHelper);

  Future<int> createPesosTreino(PesosTreino pesosTreino) async {
    final db = await databaseHelper.database;
    return await db.insert('pesos_treino', pesosTreino.toMap());
  }

  Future<List<PesosTreino>> getPesosTreinoByUserId(int userId) async {
    final db = await databaseHelper.database;
    final result = await db.query('pesos_treino', where: 'userId = ?', whereArgs: [userId]);
    return result.map((e) => PesosTreino.fromMap(e)).toList();
  }

  Future<List<PesosTreino>> getPesosTreinoByPacoteTreinoId(int pacoteTreinoId) async {
    final db = await databaseHelper.database;
    final result = await db.query('pesos_treino', where: 'pacoteTreinoId = ?', whereArgs: [pacoteTreinoId]);
    return result.map((e) => PesosTreino.fromMap(e)).toList();
  }

  Future<int> updatePesosTreino(PesosTreino pesosTreino) async {
    final db = await databaseHelper.database;
    return await db.update('pesos_treino', pesosTreino.toMap(), where: 'id = ?', whereArgs: [pesosTreino.id]);
  }

  Future<int> deletePesosTreino(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('pesos_treino', where: 'id = ?', whereArgs: [id]);
  }
}
