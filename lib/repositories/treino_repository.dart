import '../models/treino_model/treino.dart';
import '../services/database_helper.dart';

class TreinoRepository {
  final DatabaseHelper databaseHelper;

  TreinoRepository(this.databaseHelper);

  Future<int> createTreino(Treino treino) async {
    final db = await databaseHelper.database;
    return await db.insert('treino', treino.toMap());
  }

  Future<List<Treino>> getAllTreinos() async {
    final db = await databaseHelper.database;
    final result = await db.query('treino');
    return result.map((e) => Treino.fromMap(e)).toList();
  }

  Future<int> updateTreino(Treino treino) async {
    final db = await databaseHelper.database;
    return await db.update('treino', treino.toMap(), where: 'id = ?', whereArgs: [treino.id]);
  }

  Future<int> deleteTreino(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('treino', where: 'id = ?', whereArgs: [id]);
  }
}
