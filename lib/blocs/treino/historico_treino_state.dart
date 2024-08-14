import 'package:equatable/equatable.dart';
import '../../models/treino_model.dart';

abstract class HistoricoTreinoState extends Equatable {
  const HistoricoTreinoState();

  @override
  List<Object?> get props => [];
}

class HistoricoTreinoInitial extends HistoricoTreinoState {}

class HistoricoTreinoLoading extends HistoricoTreinoState {}

class HistoricoTreinoLoaded extends HistoricoTreinoState {
  final List<HistoricoTreino> historicoTreino;

  const HistoricoTreinoLoaded(this.historicoTreino);

  @override
  List<Object?> get props => [historicoTreino];
}

class HistoricoTreinoError extends HistoricoTreinoState {
  final String message;

  const HistoricoTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
