import 'package:equatable/equatable.dart';
import '../../models/treino_model/treino.dart';

abstract class TreinoEvent extends Equatable {
  const TreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTreinos extends TreinoEvent {}

class CreateTreino extends TreinoEvent {
  final Treino treino;

  const CreateTreino(this.treino);

  @override
  List<Object?> get props => [treino];
}

class UpdateTreino extends TreinoEvent {
  final Treino treino;

  const UpdateTreino(this.treino);

  @override
  List<Object?> get props => [treino];
}

class DeleteTreino extends TreinoEvent {
  final int id;

  const DeleteTreino(this.id);

  @override
  List<Object?> get props => [id];
}
