import 'package:equatable/equatable.dart';
import 'package:guido_power_academia/models/treino_model/user_pacote_treino.dart';

abstract class UserPacoteTreinoState extends Equatable {
  const UserPacoteTreinoState();

  @override
  List<Object?> get props => [];
}

class UserPacoteTreinoInitial extends UserPacoteTreinoState {}

class UserPacoteTreinoLoading extends UserPacoteTreinoState {}

class UserPacoteTreinoLoaded extends UserPacoteTreinoState {
  final List<UserPacoteTreino> userPacotesTreino;
  final List<int> pacoteIds;

  const UserPacoteTreinoLoaded(this.pacoteIds, this.userPacotesTreino);

  @override
  List<Object?> get props => [pacoteIds, userPacotesTreino];
}

class UserPacoteTreinoError extends UserPacoteTreinoState {
  final String message;

  const UserPacoteTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
