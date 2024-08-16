import 'package:equatable/equatable.dart';

abstract class TrainerState extends Equatable {
  const TrainerState();

  @override
  List<Object?> get props => [];
}

class TrainerInitial extends TrainerState {}

class TrainersLoading extends TrainerState {}

class TrainersLoaded extends TrainerState {
  final List<dynamic> trainers;

  const TrainersLoaded(this.trainers);

  @override
  List<Object?> get props => [trainers];
}

class ToTrainersSearchLoaded extends TrainerState {
  final List<dynamic> toSearchTrainers;

  const ToTrainersSearchLoaded(this.toSearchTrainers);

  @override
  List<Object?> get props => [toSearchTrainers];
}

class TrainerError extends TrainerState {
  final String message;

  const TrainerError(this.message);

  @override
  List<Object?> get props => [message];
}
