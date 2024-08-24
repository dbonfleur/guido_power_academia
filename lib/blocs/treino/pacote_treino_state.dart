import 'package:equatable/equatable.dart';

import '../../models/treino_model/pacote_treino.dart';


abstract class PacoteTreinoState extends Equatable {
  const PacoteTreinoState();

  @override
  List<Object?> get props => [];
}

class PacoteTreinoInitial extends PacoteTreinoState {}

class PacotesTreinoLoading extends PacoteTreinoState {}

class PacotesTreinoLoaded extends PacoteTreinoState {
  final List<PacoteTreino> pacotesTreino;

  const PacotesTreinoLoaded(this.pacotesTreino);

  @override
  List<Object?> get props => [pacotesTreino];
}

class PacoteTreinosByIdLoaded extends PacoteTreinoState {
  final PacoteTreino pacoteTreino;

  const PacoteTreinosByIdLoaded(this.pacoteTreino);

  @override
  List<Object?> get props => [pacoteTreino];
}

class PacoteTreinoError extends PacoteTreinoState {
  final String message;

  const PacoteTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
