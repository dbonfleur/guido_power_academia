import 'package:equatable/equatable.dart';

import '../../models/treino_model/user_pacote_treino.dart';


abstract class UserPacoteTreinoEvent extends Equatable {
  const UserPacoteTreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserPacoteTreino extends UserPacoteTreinoEvent {}

class LoadUserPacotesTreino extends UserPacoteTreinoEvent {
  final int userId;

  const LoadUserPacotesTreino(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateUserPacoteTreino extends UserPacoteTreinoEvent {
  final UserPacoteTreino userPacoteTreino;

  const CreateUserPacoteTreino(this.userPacoteTreino);

  @override
  List<Object?> get props => [userPacoteTreino];
}

class UpdateUserPacoteTreino extends UserPacoteTreinoEvent {
  final UserPacoteTreino userPacoteTreino;

  const UpdateUserPacoteTreino(this.userPacoteTreino);

  @override
  List<Object?> get props => [userPacoteTreino];
}

class DeleteUserPacoteTreino extends UserPacoteTreinoEvent {
  final int id;

  const DeleteUserPacoteTreino(this.id);

  @override
  List<Object?> get props => [id];
}
