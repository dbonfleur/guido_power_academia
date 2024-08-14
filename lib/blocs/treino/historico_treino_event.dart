import 'package:equatable/equatable.dart';
import '../../models/treino_model.dart';

abstract class HistoricoTreinoEvent extends Equatable {
  const HistoricoTreinoEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoricoTreino extends HistoricoTreinoEvent {
  final int userPacoteTreinoId;

  const LoadHistoricoTreino(this.userPacoteTreinoId);

  @override
  List<Object?> get props => [userPacoteTreinoId];
}

class CreateHistoricoTreino extends HistoricoTreinoEvent {
  final HistoricoTreino historicoTreino;

  const CreateHistoricoTreino(this.historicoTreino);

  @override
  List<Object?> get props => [historicoTreino];
}
