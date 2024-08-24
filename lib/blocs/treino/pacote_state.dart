import 'package:equatable/equatable.dart';

import '../../models/treino_model/pacote.dart';

abstract class PacoteState extends Equatable {
  const PacoteState();

  @override
  List<Object?> get props => [];
}

class PacoteInitial extends PacoteState {}

class PacoteLoading extends PacoteState {}

class PacoteLoaded extends PacoteState {
  final Pacote pacote;
  final List<int> treinoIds;

  const PacoteLoaded(this.pacote, this.treinoIds);

  @override
  List<Object?> get props => [pacote, treinoIds];
}

class PacotesLoaded extends PacoteState {
  final List<Pacote> pacotes;

  const PacotesLoaded(this.pacotes);

  @override
  List<Object?> get props => [pacotes];
}

class PacoteError extends PacoteState {
  final String message;

  const PacoteError(this.message);

  @override
  List<Object?> get props => [message];
}
