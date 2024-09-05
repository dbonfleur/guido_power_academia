part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserCreated extends UserState {
  final int id;

  const UserCreated({required this.id});

  @override
  List<Object?> get props => [id];
}


class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}