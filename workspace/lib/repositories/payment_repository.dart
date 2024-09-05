import '../models/payment_model.dart';
import '../services/database_helper.dart';

class PaymentRepository {
  final DatabaseHelper databaseHelper;

  PaymentRepository(this.databaseHelper);

  Future<int> createPayment(Payment payment) async {
    final db = await databaseHelper.database;
    final id = await db.insert('payment', payment.toMap());
    return id;
  }

  Future<List<Payment>> getPaymentsByContract(int contractId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'payment',
      where: 'contractId = ?',
      whereArgs: [contractId],
    );

    return maps.isNotEmpty
        ? maps.map((map) => Payment.fromMap(map)).toList()
        : <Payment>[];
  }

  Future<void> updatePayment(Payment payment) async {
    final db = await databaseHelper.database;
    await db.update(
      'payment',
      payment.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  Future<void> deletePayment(int paymentId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'payment',
      where: 'id = ?',
      whereArgs: [paymentId],
    );
  }
}
