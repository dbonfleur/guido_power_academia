import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String username;
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String password;
  final String paymentMethod;
  final int contractDuration;
  final String accountType;
  final String? imageUrl;

  User({
    this.id,
    required this.username,
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.paymentMethod,
    required this.contractDuration,
    required this.accountType,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'paymentMethod': paymentMethod,
      'contractDuration': contractDuration,
      'accountType': accountType,
      'imageUrl': imageUrl,
    };
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
