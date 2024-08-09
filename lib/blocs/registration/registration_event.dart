part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUser extends RegistrationEvent {
  final String username;
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String password;
  final String paymentMethod;
  final int contractDuration;
  final String accountType;
  final String? imageUrl;

  const RegisterUser({
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

  @override
  List<Object?> get props => [
        username,
        fullName,
        dateOfBirth,
        email,
        password,
        paymentMethod,
        contractDuration,
        accountType,
        imageUrl,
      ];
}
