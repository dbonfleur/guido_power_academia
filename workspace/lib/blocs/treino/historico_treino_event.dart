import 'package:equatable/equatable.dart';

import '../../models/treino_model/historico_treino.dart';

abstract class HistoricoTreinoEvent extends Equatable {
  const HistoricoTreinoEvent();

  @override
  List<Object?> get props => [];
}

class SaveWorkoutTime extends HistoricoTreinoEvent {
  final HistoricoTreino historicoTreino;

  const SaveWorkoutTime(this.historicoTreino);

  @override
  List<Object?> get props => [historicoTreino];
}

class LoadHistoricoTreino extends HistoricoTreinoEvent {}

class StartWorkoutTimer extends HistoricoTreinoEvent {}

class StopWorkoutTimer extends HistoricoTreinoEvent {}

class UpdateWorkoutTimer extends HistoricoTreinoEvent {
  final int timeInSeconds;

  const UpdateWorkoutTimer(this.timeInSeconds);

  @override
  List<Object?> get props => [timeInSeconds];
}

class ResetWorkoutTimer extends HistoricoTreinoEvent {}
