import '../models/treino_model.dart';
import '../services/database_helper.dart';

class TreinoRepository {
  final DatabaseHelper databaseHelper;

  TreinoRepository(this.databaseHelper);

  // Métodos relacionados a Treino
  Future<List<Treino>> getAllTreinos() async {
    final db = await databaseHelper.database;
    final maps = await db.query('treino');
    return List.generate(maps.length, (i) => Treino.fromMap(maps[i]));
  }

  Future<int> createTreino(Treino treino) async {
    final db = await databaseHelper.database;
    return db.insert('treino', treino.toMap());
  }

  Future<int> updateTreino(Treino treino) async {
    final db = await databaseHelper.database;
    return db.update('treino', treino.toMap(), where: 'id = ?', whereArgs: [treino.id]);
  }

  Future<int> deleteTreino(int id) async {
    final db = await databaseHelper.database;
    return db.delete('treino', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos relacionados a PacoteTreino
  Future<List<PacoteTreino>> getAllPacotesTreino() async {
    final db = await databaseHelper.database;
    final pacoteTreinoMaps = await db.query('pacote_treino');

    List<PacoteTreino> pacotesTreino = [];

    for (var pacoteMap in pacoteTreinoMaps) {
      final treinoMaps = await db.query(
        'treino',
        where: 'pacoteTreinoId = ?',
        whereArgs: [pacoteMap['id']],
      );
      List<Treino> treinos = List.generate(treinoMaps.length, (i) => Treino.fromMap(treinoMaps[i]));
      pacotesTreino.add(PacoteTreino.fromMap(pacoteMap, treinos));
    }

    return pacotesTreino;
  }

  Future<int> createPacoteTreino(PacoteTreino pacoteTreino) async {
    final db = await databaseHelper.database;
    return db.insert('pacote_treino', pacoteTreino.toMap());
  }

  Future<int> updatePacoteTreino(PacoteTreino pacoteTreino) async {
    final db = await databaseHelper.database;
    return db.update('pacote_treino', pacoteTreino.toMap(), where: 'id = ?', whereArgs: [pacoteTreino.id]);
  }

  Future<int> deletePacoteTreino(int id) async {
    final db = await databaseHelper.database;
    return db.delete('pacote_treino', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos relacionados a UserPacoteTreino
  Future<List<UserPacoteTreino>> getAllUserPacotesTreino() async {
    final db = await databaseHelper.database;
    final userPacoteTreinoMaps = await db.query('user_pacote_treino');
    List<UserPacoteTreino> userPacotesTreino = [];

    for (var userPacoteMap in userPacoteTreinoMaps) {
        final pacoteTreinoMaps = await db.query(
            'pacote_treino',
            where: 'id = ?',
            whereArgs: [userPacoteMap['pacoteTreinoId']],
        );
        if (pacoteTreinoMaps.isNotEmpty) {
            final pacoteTreino = PacoteTreino.fromMap(pacoteTreinoMaps.first, []);
            userPacotesTreino.add(UserPacoteTreino.fromMap(userPacoteMap, pacoteTreino));
        }
    }

    return userPacotesTreino;
  }

  Future<int> createUserPacoteTreino(UserPacoteTreino userPacoteTreino) async {
    final db = await databaseHelper.database;
    return db.insert('user_pacote_treino', userPacoteTreino.toMap());
  }

  Future<int> updateUserPacoteTreino(UserPacoteTreino userPacoteTreino) async {
    final db = await databaseHelper.database;
    return db.update('user_pacote_treino', userPacoteTreino.toMap(), where: 'id = ?', whereArgs: [userPacoteTreino.id]);
  }

  Future<int> deleteUserPacoteTreino(int id) async {
    final db = await databaseHelper.database;
    return db.delete('user_pacote_treino', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos relacionados a PesosTreino
  Future<List<PesosTreino>> getPesosTreinoByUserId(int userId) async {
    final db = await databaseHelper.database;
    final pesosTreinoMaps = await db.query('pesos_treino', where: 'userId = ?', whereArgs: [userId]);
    List<PesosTreino> pesosTreinoList = [];

    for (var pesoTreinoMap in pesosTreinoMaps) {
        final treinoMaps = await db.query(
            'treino',
            where: 'id = ?',
            whereArgs: [pesoTreinoMap['treinoId']],
        );
        if (treinoMaps.isNotEmpty) {
            final treino = Treino.fromMap(treinoMaps.first);
            pesosTreinoList.add(PesosTreino.fromMap(pesoTreinoMap, treino));
        }
    }

    return pesosTreinoList;
  }

  Future<int> createPesosTreino(PesosTreino pesosTreino) async {
    final db = await databaseHelper.database;
    return db.insert('pesos_treino', pesosTreino.toMap());
  }

  Future<int> updatePesosTreino(PesosTreino pesosTreino) async {
    final db = await databaseHelper.database;
    return db.update('pesos_treino', pesosTreino.toMap(), where: 'id = ?', whereArgs: [pesosTreino.id]);
  }

  Future<int> deletePesosTreino(int id) async {
    final db = await databaseHelper.database;
    return db.delete('pesos_treino', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos relacionados a HistoricoTreino
  Future<List<HistoricoTreino>> getHistoricoTreinoByUserPacoteTreinoId(int userPacoteTreinoId) async {
    final db = await databaseHelper.database;
    final historicoTreinoMaps = await db.query('historico_treino', where: 'userPacoteTreinoId = ?', whereArgs: [userPacoteTreinoId]);
    List<HistoricoTreino> historicoTreinoList = [];

    for (var historicoMap in historicoTreinoMaps) {
        final userPacoteTreinoMaps = await db.query(
            'user_pacote_treino',
            where: 'id = ?',
            whereArgs: [historicoMap['userPacoteTreinoId']],
        );
        if (userPacoteTreinoMaps.isNotEmpty) {
            final pacoteTreinoMaps = await db.query(
                'pacote_treino',
                where: 'id = ?',
                whereArgs: [userPacoteTreinoMaps.first['pacoteTreinoId']],
            );
            if (pacoteTreinoMaps.isNotEmpty) {
                final pacoteTreino = PacoteTreino.fromMap(pacoteTreinoMaps.first, []);
                final userPacoteTreino = UserPacoteTreino.fromMap(userPacoteTreinoMaps.first, pacoteTreino);
                historicoTreinoList.add(HistoricoTreino.fromMap(historicoMap, userPacoteTreino));
            }
        }
    }

    return historicoTreinoList;
  }

  Future<int> createHistoricoTreino(HistoricoTreino historicoTreino) async {
    final db = await databaseHelper.database;
    return db.insert('historico_treino', historicoTreino.toMap());
  }
}
