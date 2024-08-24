import 'package:equatable/equatable.dart';

import '../../models/treino_model/user_pacote_treino.dart';


abstract class UserPacoteTreinoState extends Equatable {
  const UserPacoteTreinoState();

  @override
  List<Object?> get props => [];
}

class UserPacoteTreinoInitial extends UserPacoteTreinoState {}

class UserPacoteTreinoLoading extends UserPacoteTreinoState {}

class UserPacoteTreinoLoaded extends UserPacoteTreinoState {
  final List<UserPacoteTreino> userPacotesTreino;

  const UserPacoteTreinoLoaded(this.userPacotesTreino);

  @override
  List<Object?> get props => [userPacotesTreino];
}

class UserPacoteTreinoError extends UserPacoteTreinoState {
  final String message;

  const UserPacoteTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
