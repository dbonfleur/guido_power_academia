import '../models/treino_model/user_pacote_treino.dart';
import '../services/database_helper.dart';

class UserPacoteTreinoRepository {
  final DatabaseHelper databaseHelper;

  UserPacoteTreinoRepository(this.databaseHelper);

  Future<int> createUserPacoteTreino(UserPacoteTreino userPacote) async {
    final db = await databaseHelper.database;
    return await db.insert('user_pacote', userPacote.toMap());
  }

  Future<List<UserPacoteTreino>> getAllUserPacotesTreino() async {
    final db = await databaseHelper.database;
    final result = await db.query('user_pacote');
    return result.map((e) => UserPacoteTreino.fromMap(e)).toList();
  }

  Future<int> updateUserPacoteTreino(UserPacoteTreino userPacote) async {
    final db = await databaseHelper.database;
    return await db.update('user_pacote', userPacote.toMap(), where: 'id = ?', whereArgs: [userPacote.id]);
  }

  Future<int> deleteUserPacoteTreino(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('user_pacote', where: 'id = ?', whereArgs: [id]);
  }
}
