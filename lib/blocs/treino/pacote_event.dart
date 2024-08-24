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

class CreatePacote extends PacoteEvent {
  final Pacote pacote;
  final List<Treino> treinos;

  const CreatePacote(this.pacote, this.treinos);

  @override
  List<Object?> get props => [pacote, treinos];
}

class UpdatePacote extends PacoteEvent {
  final Pacote pacote;

  const UpdatePacote(this.pacote);

  @override
  List<Object?> get props => [pacote];
}

class DeletePacote extends PacoteEvent {
  final int id;

  const DeletePacote(this.id);

  @override
  List<Object?> get props => [id];
}
