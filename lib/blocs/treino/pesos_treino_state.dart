import 'package:equatable/equatable.dart';
import '../../models/treino_model/peso_treino.dart';

abstract class PesosTreinoState extends Equatable {
  const PesosTreinoState();

  @override
  List<Object?> get props => [];
}

class PesosTreinoInitial extends PesosTreinoState {}

class PesosTreinoLoading extends PesosTreinoState {}

class PesosTreinoLoaded extends PesosTreinoState {
  final List<PesosTreino> pesosTreinos;

  const PesosTreinoLoaded(this.pesosTreinos);

  @override
  List<Object?> get props => [pesosTreinos];
}

class PesosTreinoError extends PesosTreinoState {
  final String message;

  const PesosTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
