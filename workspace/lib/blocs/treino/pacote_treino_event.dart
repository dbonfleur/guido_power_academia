import 'package:equatable/equatable.dart';

import '../../models/treino_model/pacote_treino.dart';


abstract class PacoteTreinoEvent extends Equatable {
  const PacoteTreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadPacoteTreino extends PacoteTreinoEvent {
  final int pacoteId;

  const LoadPacoteTreino(this.pacoteId);

  @override
  List<Object?> get props => [pacoteId];
}

class LoadPacoteTreinosById extends PacoteTreinoEvent {
  final int pacoteId;

  const LoadPacoteTreinosById(this.pacoteId);

  @override
  List<Object?> get props => [pacoteId];
}

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

class GetPacoteTreinoIdByAlunoIdAndTreinoId extends PacoteTreinoEvent {
  final int alunoId;
  final int treinoId;

  const GetPacoteTreinoIdByAlunoIdAndTreinoId(this.alunoId, this.treinoId);

  @override
  List<Object?> get props => [alunoId, treinoId];
}
