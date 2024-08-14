import 'package:equatable/equatable.dart';
import '../../models/treino_model.dart';

abstract class PesosTreinoState extends Equatable {
  const PesosTreinoState();

  @override
  List<Object?> get props => [];
}

class PesosTreinoInitial extends PesosTreinoState {}

class PesosTreinoLoading extends PesosTreinoState {}

class PesosTreinoLoaded extends PesosTreinoState {
  final List<PesosTreino> pesosTreino;

  const PesosTreinoLoaded(this.pesosTreino);

  @override
  List<Object?> get props => [pesosTreino];
}

class PesosTreinoError extends PesosTreinoState {
  final String message;

  const PesosTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
