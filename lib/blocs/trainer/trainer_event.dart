import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class TrainerEvent extends Equatable {
  const TrainerEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrainers extends TrainerEvent {}

class AddTrainer extends TrainerEvent {
  final User user;

  const AddTrainer(this.user);

  @override
  List<Object?> get props => [user];
}

class RemoveTrainer extends TrainerEvent {
  final User user;

  const RemoveTrainer(this.user);

  @override
  List<Object?> get props => [user];
}