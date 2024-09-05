import '../models/mural_model.dart';
import '../services/database_helper.dart';

class MuralRepository {
  final DatabaseHelper databaseHelper;

  MuralRepository(this.databaseHelper);

  Future<List<Mural>> getAllMurals() async {
    final db = await databaseHelper.database;
    final result = await db.query('murals');
    return result.map((json) => Mural.fromJson(json)).toList();
  }

  Future<void> insertMural(Mural mural) async {
    final db = await databaseHelper.database;
    await db.insert('murals', mural.toJson());
  }

  Future<void> updateMural(Mural mural) async {
    final db = await databaseHelper.database;
    await db.update(
      'murals',
      mural.toJson(),
      where: 'id = ?',
      whereArgs: [mural.id],
    );
  }

  Future<void> deleteMural(int id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'murals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
