import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/treino_repository.dart';
import 'pacote_treino_event.dart';
import 'pacote_treino_state.dart';

class PacoteTreinoBloc extends Bloc<PacoteTreinoEvent, PacoteTreinoState> {
  final TreinoRepository treinoRepository;

  PacoteTreinoBloc(this.treinoRepository) : super(PacoteTreinoInitial()) {
    on<LoadPacotesTreino>(_onLoadPacotesTreino);
    on<CreatePacoteTreino>(_onCreatePacoteTreino);
    on<UpdatePacoteTreino>(_onUpdatePacoteTreino);
    on<DeletePacoteTreino>(_onDeletePacoteTreino);
  }

  Future<void> _onLoadPacotesTreino(LoadPacotesTreino event, Emitter<PacoteTreinoState> emit) async {
    emit(PacoteTreinoLoading());
    try {
      final pacotesTreino = await treinoRepository.getAllPacotesTreino();
      emit(PacoteTreinoLoaded(pacotesTreino));
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onCreatePacoteTreino(CreatePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    try {
      await treinoRepository.createPacoteTreino(event.pacoteTreino);
      add(LoadPacotesTreino());
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onUpdatePacoteTreino(UpdatePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    try {
      await treinoRepository.updatePacoteTreino(event.pacoteTreino);
      add(LoadPacotesTreino());
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onDeletePacoteTreino(DeletePacoteTreino event, Emitter<PacoteTreinoState> emit) async {
    try {
      await treinoRepository.deletePacoteTreino(event.id);
      add(LoadPacotesTreino());
    } catch (e) {
      emit(PacoteTreinoError(e.toString()));
    }
  }
}
