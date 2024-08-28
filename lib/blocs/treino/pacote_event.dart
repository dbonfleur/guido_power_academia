import 'package:equatable/equatable.dart';
import '../../models/treino_model/pacote.dart';
import '../../models/treino_model/treino.dart';

abstract class PacoteEvent extends Equatable {
  const PacoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadPacotes extends PacoteEvent {}

class LoadPacoteById extends PacoteEvent {
  final int pacoteId;

  const LoadPacoteById(this.pacoteId);

  @override
  List<Object?> get props => [pacoteId];
}

class LoadPacotesById extends PacoteEvent {
  final List<int> pacotesIds;

  const LoadPacotesById(this.pacotesIds);

  @override
  List<Object?> get props => [pacotesIds];
}

class CreatePacote extends PacoteEvent {
  final Pacote pacote;
  final List<Treino> treinos;

  const CreatePacote(this.pacote, this.treinos);

  @override
  List<Object?> get props => [pacote, treinos];
}

class UpdatePacote extends PacoteEvent {
  final Pacote pacote;
  final List<Treino> treinos;

  const UpdatePacote(this.pacote, this.treinos);

  @override
  List<Object?> get props => [pacote, treinos];
}

class DeletePacote extends PacoteEvent {
  final int id;

  const DeletePacote(this.id);

  @override
  List<Object?> get props => [id];
}
