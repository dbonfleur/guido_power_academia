import '../models/user_model.dart';
import '../services/database_helper.dart';

class UserRepository {
  final DatabaseHelper databaseHelper;

  UserRepository(this.databaseHelper);

  Future<void> createUser(User user) async {
    await databaseHelper.createUser(user);
  }

  Future<void> updateUser(User user) async {
    await databaseHelper.updateUser(user);
  }

  Future<User?> authenticate(String username, String password) async {
    return await databaseHelper.getUser(username, password);
  }

  Future<User?> getUserByUsername(String username) async {
    return await databaseHelper.getUserByUsername(username);
  }

  Future<User?> getUserById(int userId) async {
    return await databaseHelper.getUserById(userId);
  }
}
