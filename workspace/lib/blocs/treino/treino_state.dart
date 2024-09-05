import 'package:equatable/equatable.dart';
import '../../models/treino_model/treino.dart';

abstract class TreinoState extends Equatable {
  const TreinoState();

  @override
  List<Object?> get props => [];
}

class TreinoInitial extends TreinoState {}

class TreinoLoading extends TreinoState {}

class TreinosLoaded extends TreinoState {
  final List<Treino> treinos;

  const TreinosLoaded(this.treinos);

  @override
  List<Object?> get props => [treinos];
}

class TreinosByIdLoaded extends TreinoState {
  final List<Treino> treinos;

  const TreinosByIdLoaded(this.treinos);

  @override
  List<Object?> get props => [treinos];
}

class TreinoError extends TreinoState {
  final String message;

  const TreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
