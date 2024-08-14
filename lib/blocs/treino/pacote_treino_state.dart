import 'package:equatable/equatable.dart';
import '../../models/treino_model.dart';

abstract class PacoteTreinoState extends Equatable {
  const PacoteTreinoState();

  @override
  List<Object?> get props => [];
}

class PacoteTreinoInitial extends PacoteTreinoState {}

class PacoteTreinoLoading extends PacoteTreinoState {}

class PacoteTreinoLoaded extends PacoteTreinoState {
  final List<PacoteTreino> pacotesTreino;

  const PacoteTreinoLoaded(this.pacotesTreino);

  @override
  List<Object?> get props => [pacotesTreino];
}

class PacoteTreinoError extends PacoteTreinoState {
  final String message;

  const PacoteTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
