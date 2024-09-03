import 'package:equatable/equatable.dart';
import '../../models/treino_model/peso_treino.dart';

abstract class PesosTreinoEvent extends Equatable {
  const PesosTreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadPesosTreino extends PesosTreinoEvent {
  final int userId;

  const LoadPesosTreino(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddPesosTreino extends PesosTreinoEvent {
  final PesosTreino pesosTreino;

  const AddPesosTreino(this.pesosTreino);

  @override
  List<Object?> get props => [pesosTreino];
}

class UpdatePesosTreino extends PesosTreinoEvent {
  final PesosTreino pesosTreino;

  const UpdatePesosTreino(this.pesosTreino);

  @override
  List<Object?> get props => [pesosTreino];
}
