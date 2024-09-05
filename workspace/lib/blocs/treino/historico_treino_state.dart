import 'package:equatable/equatable.dart';

abstract class HistoricoTreinoState extends Equatable {
  const HistoricoTreinoState();

  @override
  List<Object?> get props => [];
}

class HistoricoTreinoInitial extends HistoricoTreinoState {}

class HistoricoTreinoLoading extends HistoricoTreinoState {}

class HistoricoTreinoLoaded extends HistoricoTreinoState {}

class WorkoutTimeStarted extends HistoricoTreinoState {}

class WorkoutTimeStopped extends HistoricoTreinoState {
  final int totalTimeInSeconds;

  const WorkoutTimeStopped(this.totalTimeInSeconds);

  @override
  List<Object?> get props => [totalTimeInSeconds];
}

class WorkoutTimeUpdated extends HistoricoTreinoState {
  final int timeInSeconds;

  const WorkoutTimeUpdated(this.timeInSeconds);

  @override
  List<Object?> get props => [timeInSeconds];
}

class HistoricoTreinoError extends HistoricoTreinoState {
  final String message;

  const HistoricoTreinoError(this.message);

  @override
  List<Object?> get props => [message];
}
