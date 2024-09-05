import '../models/contract_model.dart';
import '../services/database_helper.dart';

class ContractRepository {
  final DatabaseHelper databaseHelper;

  ContractRepository(this.databaseHelper);

  Future<int> createContract(Contract contract) async {
    final db = await databaseHelper.database;
    final id = await db.insert('contract', contract.toMap());
    return id;
  }

  Future<List<Contract>> getContractsByUser(int userId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'contract',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.isNotEmpty
        ? maps.map((map) => Contract.fromMap(map)).toList()
        : <Contract>[];
  }

  Future<void> updateContract(Contract contract) async {
    final db = await databaseHelper.database;
    await db.update(
      'contract',
      contract.toMap(),
      where: 'id = ?',
      whereArgs: [contract.id],
    );
  }

  Future<void> deleteContract(int contractId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'contract',
      where: 'id = ?',
      whereArgs: [contractId],
    );
  }
}
