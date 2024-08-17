part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class CreateUser extends UserEvent {
  final User user;

  const CreateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoadUser extends UserEvent {
  final int userId;

  const LoadUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserName extends UserEvent {
  final String fullName;

  const UpdateUserName(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class UpdateUserDateOfBirth extends UserEvent {
  final String dateOfBirth;

  const UpdateUserDateOfBirth(this.dateOfBirth);

  @override
  List<Object?> get props => [dateOfBirth];
}

class UpdateUserPaymentMethod extends UserEvent {
  final String paymentMethod;

  const UpdateUserPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdateUserImage extends UserEvent {
  final String? imageUrl;

  const UpdateUserImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class UpdateUserPassword extends UserEvent {
  final String oldPassword;
  final String newPassword;

  const UpdateUserPassword(this.oldPassword, this.newPassword);

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class LogoutUserEvent extends UserEvent {}