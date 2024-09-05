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
  final String accountType;
  final String paymentMethod;
  final int contractDuration;
  final String? imageUrl;
  final BuildContext context;

  const RegisterUser({
    required this.username,
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.accountType,
    required this.paymentMethod,
    required this.contractDuration,
    this.imageUrl,
    required this.context,
  });
}

