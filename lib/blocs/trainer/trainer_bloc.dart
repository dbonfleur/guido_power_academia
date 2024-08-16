import 'package:flutter_bloc/flutter_bloc.dart';
import 'trainer_event.dart';
import 'trainer_state.dart';
import '../../repositories/user_repository.dart';

class TrainerBloc extends Bloc<TrainerEvent, TrainerState> {
  final UserRepository userRepository;

  TrainerBloc(this.userRepository) : super(TrainerInitial()) {
    on<LoadTrainers>(_onLoadTrainers);
    on<AddTrainer>(_onAddTrainer);
    on<RemoveTrainer>(_onRemoveTrainer);
  }

  Future<void> _onLoadTrainers(LoadTrainers event, Emitter<TrainerState> emit) async {
    emit(TrainersLoading());
    try {
      final trainers = await userRepository.getUsersByAccountType('treinador');
      emit(TrainersLoaded(trainers));
    } catch (e) {
      emit(TrainerError(e.toString()));
    }
  }

  Future<void> _onAddTrainer(AddTrainer event, Emitter<TrainerState> emit) async {
    if (state is TrainersLoaded) {
      try {
        final updatedUser = event.user.copyWithAccountType('treinador');
        await userRepository.updateUser(updatedUser);
        final updatedTrainers = List.from((state as TrainersLoaded).trainers)..add(updatedUser);
        emit(TrainersLoaded(updatedTrainers));
      } catch (e) {
        emit(TrainerError(e.toString()));
      }
    }
  }

  Future<void> _onRemoveTrainer(RemoveTrainer event, Emitter<TrainerState> emit) async {
    if (state is TrainersLoaded) {
      try {
        final updatedUser = event.user.copyWithAccountType('aluno');
        await userRepository.updateUser(updatedUser);
        final updatedTrainers = List.from((state as TrainersLoaded).trainers)
          ..removeWhere((trainer) => trainer.id == event.user.id);
        emit(TrainersLoaded(updatedTrainers));
      } catch (e) {
        emit(TrainerError(e.toString()));
      }
    }
  }
}
