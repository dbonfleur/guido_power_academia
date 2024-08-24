import 'package:equatable/equatable.dart';

import '../../models/treino_model/pacote_treino.dart';


abstract class PacoteTreinoEvent extends Equatable {
  const PacoteTreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadPacotesTreino extends PacoteTreinoEvent {}

class CreatePacoteTreino extends PacoteTreinoEvent {
  final PacoteTreino pacoteTreino;

  const CreatePacoteTreino(this.pacoteTreino);

  @override
  List<Object?> get props => [pacoteTreino];
}

class UpdatePacoteTreino extends PacoteTreinoEvent {
  final PacoteTreino pacoteTreino;

  const UpdatePacoteTreino(this.pacoteTreino);

  @override
  List<Object?> get props => [pacoteTreino];
}

class DeletePacoteTreino extends PacoteTreinoEvent {
  final int id;

  const DeletePacoteTreino(this.id);

  @override
  List<Object?> get props => [id];
}
