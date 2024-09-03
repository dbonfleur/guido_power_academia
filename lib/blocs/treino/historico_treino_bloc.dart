import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/historico_treino_repository.dart';
import 'historico_treino_event.dart';
import 'historico_treino_state.dart';

class HistoricoTreinoBloc extends Bloc<HistoricoTreinoEvent, HistoricoTreinoState> {
  final HistoricoTreinoRepository historicoTreinoRepo;
  Timer? _workoutTimer;
  int _workoutTimeInSeconds = 0;

  HistoricoTreinoBloc(this.historicoTreinoRepo) : super(HistoricoTreinoInitial()) {
    on<SaveWorkoutTime>(_onSaveWorkoutTime);
    on<LoadHistoricoTreino>(_onLoadHistoricoTreino);
    on<StartWorkoutTimer>(_onStartWorkoutTimer);
    on<StopWorkoutTimer>(_onStopWorkoutTimer);
    on<UpdateWorkoutTimer>(_onUpdateWorkoutTimer);
    on<ResetWorkoutTimer>(_onResetWorkoutTimer);
  }
  Future<void> _onSaveWorkoutTime(SaveWorkoutTime event, Emitter<HistoricoTreinoState> emit) async {
    try {
      await historicoTreinoRepo.createHistoricoTreino(event.historicoTreino);
      emit(HistoricoTreinoLoaded());
    } catch (e) {
      emit(HistoricoTreinoError("Erro ao salvar o histórico de treino: ${e.toString()}"));
    }
  }

  Future<void> _onLoadHistoricoTreino(LoadHistoricoTreino event, Emitter<HistoricoTreinoState> emit) async {
    emit(HistoricoTreinoLoading());
    try {
      emit(const WorkoutTimeStopped(0));
    } catch (e) {
      emit(const HistoricoTreinoError("Erro ao carregar o histórico de treino"));
    }
  }

  void _onStartWorkoutTimer(StartWorkoutTimer event, Emitter<HistoricoTreinoState> emit) {
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _workoutTimeInSeconds++;
      add(UpdateWorkoutTimer(_workoutTimeInSeconds));
    });
    emit(WorkoutTimeStarted());
  }

  void _onStopWorkoutTimer(StopWorkoutTimer event, Emitter<HistoricoTreinoState> emit) {
    _workoutTimer?.cancel();
    emit(WorkoutTimeStopped(_workoutTimeInSeconds));
  }

  void _onUpdateWorkoutTimer(UpdateWorkoutTimer event, Emitter<HistoricoTreinoState> emit) {
    emit(WorkoutTimeUpdated(event.timeInSeconds));
  }

  void _onResetWorkoutTimer(ResetWorkoutTimer event, Emitter<HistoricoTreinoState> emit) {
    _workoutTimer?.cancel();
    _workoutTimeInSeconds = 0;
    emit(HistoricoTreinoInitial());
  }

  @override
  Future<void> close() {
    _workoutTimer?.cancel();
    return super.close();
  }
}
