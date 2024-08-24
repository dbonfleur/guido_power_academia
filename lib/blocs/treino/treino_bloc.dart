import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/treino_repository.dart';
import 'treino_event.dart';
import 'treino_state.dart';

class TreinoBloc extends Bloc<TreinoEvent, TreinoState> {
  final TreinoRepository treinoRepository;

  TreinoBloc(this.treinoRepository) : super(TreinoInitial()) {
    on<LoadTreinos>(_onLoadTreinos);
    on<CreateTreino>(_onCreateTreino);
    on<UpdateTreino>(_onUpdateTreino);
    on<DeleteTreino>(_onDeleteTreino);
    on<LoadTreinosByIds>(_onLoadTreinosByIds);
  }

  Future<void> _onLoadTreinos(LoadTreinos event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final treinos = await treinoRepository.getAllTreinos();
      emit(TreinosLoaded(treinos));
    } catch (e) {
      emit(TreinoError(e.toString()));
    }
  }

  Future<void> _onLoadTreinosByIds(LoadTreinosByIds event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final treinos = await treinoRepository.getTreinosByIds(event.treinoIds);
      emit(TreinosByIdLoaded(treinos));
    } catch (e) {
      emit(TreinoError(e.toString()));
    }
  }

  Future<void> _onCreateTreino(CreateTreino event, Emitter<TreinoState> emit) async {
    try {
      await treinoRepository.createTreino(event.treino);
      add(LoadTreinos());
    } catch (e) {
      emit(TreinoError(e.toString()));
    }
  }

  Future<void> _onUpdateTreino(UpdateTreino event, Emitter<TreinoState> emit) async {
    try {
      await treinoRepository.updateTreino(event.treino);
      add(LoadTreinos());
    } catch (e) {
      emit(TreinoError(e.toString()));
    }
  }

  Future<void> _onDeleteTreino(DeleteTreino event, Emitter<TreinoState> emit) async {
    try {
      await treinoRepository.deleteTreino(event.id);
      add(LoadTreinos());
    } catch (e) {
      emit(TreinoError(e.toString()));
    }
  }
}
