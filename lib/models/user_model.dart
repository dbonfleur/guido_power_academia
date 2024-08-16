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

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

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

  User copyWithPassword({
    required String password,
  }) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accountType,
      imageUrl: imageUrl,
    );
  }

  copyWithUserImage({
    String? imageUrl
  }) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accountType,
      imageUrl: imageUrl,
    );
  }

  copyWithPaymentMethod({required String paymentMethod}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accountType,
      imageUrl: imageUrl,
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
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accountType,
      imageUrl: imageUrl,
    );
  }

  copyWithUserName({required String fullName}) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accountType,
      imageUrl: imageUrl,
    );
  }

  static fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      fullName: map['fullName'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      paymentMethod: map['paymentMethod'] as String,
      contractDuration: map['contractDuration'] as int,
      accountType: map['accountType'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  copyWithAccountType(String accType) {
    return User(
      id: id,
      username: username,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      paymentMethod: paymentMethod,
      contractDuration: contractDuration,
      accountType: accType,
      imageUrl: imageUrl,
    );
  }
}