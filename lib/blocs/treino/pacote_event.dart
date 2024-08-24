import 'package:equatable/equatable.dart';

import '../../models/treino_model/pacote.dart';

abstract class PacoteEvent extends Equatable {
  const PacoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadPacotes extends PacoteEvent {}

class CreatePacote extends PacoteEvent {
  final Pacote pacote;

  const CreatePacote(this.pacote);

  @override
  List<Object?> get props => [pacote];
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
