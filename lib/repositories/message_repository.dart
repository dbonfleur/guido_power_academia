import '../models/message_model.dart';
import '../services/database_helper.dart';

class MessageRepository {
  final DatabaseHelper databaseHelper;

  MessageRepository({required this.databaseHelper});

  Future<List<Message>> getAllMessages() async {
    final db = await databaseHelper.database;
    final result = await db.query('messages');
    return result.map((json) => Message.fromJson(json)).toList();
  }

  Future<void> insertMessage(Message message) async {
    final db = await databaseHelper.database;
    await db.insert('messages', message.toJson());
  }

  Future<void> updateMessage(Message message) async {
    final db = await databaseHelper.database;
    await db.update(
      'messages',
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<void> deleteMessage(int id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
