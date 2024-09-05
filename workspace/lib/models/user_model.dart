import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String username;
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String password;
  final String accountType;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.accountType,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'accountType': accountType,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static User fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      fullName: map['fullName'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      accountType: map['accountType'] as String,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String), 
    );
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  copyWithUserName({required String fullName}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  copyWithDateOfBirth({required String dateOfBirth}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  copyWithUserImage({String? imageUrl}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  copyWithPassword({required String password}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  copyWithAccountType(String accountType) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  copyWithUpdatedAt(DateTime updatedAt) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      accountType: accountType,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
