import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pacote_repository.dart';
import 'pacote_event.dart';
import 'pacote_state.dart';

class PacoteBloc extends Bloc<PacoteEvent, PacoteState> {
  final PacoteRepository pacoteRepository;

  PacoteBloc(this.pacoteRepository) : super(PacoteInitial()) {
    on<LoadPacotes>(_onLoadPacotes);
    on<CreatePacote>(_onCreatePacote);
    on<UpdatePacote>(_onUpdatePacote);
    on<DeletePacote>(_onDeletePacote);
  }

  Future<void> _onLoadPacotes(LoadPacotes event, Emitter<PacoteState> emit) async {
    emit(PacoteLoading());
    try {
      final pacotes = await pacoteRepository.getAllPacotes();
      emit(PacoteLoaded(pacotes));
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onCreatePacote(CreatePacote event, Emitter<PacoteState> emit) async {
    try {
      await pacoteRepository.createPacote(event.pacote);
      add(LoadPacotes());
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onUpdatePacote(UpdatePacote event, Emitter<PacoteState> emit) async {
    try {
      await pacoteRepository.updatePacote(event.pacote);
      add(LoadPacotes());
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onDeletePacote(DeletePacote event, Emitter<PacoteState> emit) async {
    try {
      await pacoteRepository.deletePacote(event.id);
      add(LoadPacotes());
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }
}
