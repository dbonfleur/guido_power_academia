import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pacote_treino_repository.dart';
import 'pacote_treino_event.dart';
import 'pacote_treino_state.dart';

class PacoteTreinoBloc extends Bloc<PacoteTreinoEvent, PacoteTreinoState> {
  final PacoteTreinoRepository pacoteTreinoRepo;

  PacoteTreinoBloc(this.pacoteTreinoRepo) : super(PacoteTreinoInitial()) {
    on<LoadPacoteTreino>(_onLoadPacotesTreino);
    on<CreatePacoteTreino>(_onCreatePacoteTreino);
    on<UpdatePacoteTreino>(_onUpdatePacoteTreino);
    on<DeletePacoteTreino>(_onDeletePacoteTreino);
    on<LoadPacoteTreinosById>(_onLoadPacoteTreinosById);
  }

  Future<void> _onLoadPacotesTreino(LoadPacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    emit(PacotesTreinoLoading());
    try {
      final pacotesTreino = await pacoteTreinoRepo.getAllPacotesTreino();
      emit(PacotesTreinoLoaded(pacotesTreino));
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onLoadPacoteTreinosById(LoadPacoteTreinosById event, Emitter<PacoteTreinoState> emit) async {
    emit(PacotesTreinoLoading());
    try {
      final treinoIds = await pacoteTreinoRepo.getTreinoIdsByPacoteId(event.pacoteId);
      emit(TreinoIdsLoaded(treinoIds));
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onCreatePacoteTreino(CreatePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
  try {
    await pacoteTreinoRepo.createPacoteTreino(event.pacoteTreino);
    add(LoadPacoteTreino(event.pacoteTreino.pacoteId));
  } catch (e) {
    emit(PacoteTreinoError(e.toString()));
  }
}

  Future<void> _onUpdatePacoteTreino(UpdatePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    try {
      final pacotesTreinos = await pacoteTreinoRepo.updatePacoteTreino(event.pacoteTreino);
      add(LoadPacoteTreino(pacotesTreinos));
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onDeletePacoteTreino(DeletePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    try {
      final pacotesTreinos = await pacoteTreinoRepo.deletePacoteTreino(event.id);
      add(LoadPacoteTreino(pacotesTreinos));
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }
}
