import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pacote_repository.dart';
import '../../repositories/pacote_treino_repository.dart';
import 'pacote_event.dart';
import 'pacote_state.dart';
import '../../models/treino_model/pacote_treino.dart';

class PacoteBloc extends Bloc<PacoteEvent, PacoteState> {
  final PacoteRepository pacoteRepository;
  final PacoteTreinoRepository pacoteTreinoRepository;

  PacoteBloc(this.pacoteRepository, this.pacoteTreinoRepository)
      : super(PacoteInitial()) {
    on<LoadPacoteById>(_onLoadPacoteById);
    on<LoadPacotes>(_onLoadPacotes);
    on<CreatePacote>(_onCreatePacote);
    on<UpdatePacote>(_onUpdatePacote);
    on<DeletePacote>(_onDeletePacote);
  }

  Future<void> _onLoadPacoteById(
      LoadPacoteById event, Emitter<PacoteState> emit) async {
    emit(PacoteLoading());
    try {
      final pacote = await pacoteRepository.getPacoteById(event.pacoteId);
      final treinoIds =
          await pacoteTreinoRepository.getTreinoIdsByPacoteId(event.pacoteId);
      emit(PacoteLoaded(pacote, treinoIds));
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onLoadPacotes(
      LoadPacotes event, Emitter<PacoteState> emit) async {
    emit(PacoteLoading());
    try {
      final pacotes = await pacoteRepository.getAllPacotes();
      emit(PacotesLoaded(pacotes));
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onCreatePacote(
      CreatePacote event, Emitter<PacoteState> emit) async {
    try {
      final pacoteId = await pacoteRepository.createPacote(event.pacote);

      final pacoteTreino = PacoteTreino(
        pacoteId: pacoteId,
        treinoIds: event.treinos.map((e) => e.id!).toList(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await pacoteTreinoRepository.createPacoteTreino(pacoteTreino);

      add(LoadPacotes());
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }

  Future<void> _onUpdatePacote(UpdatePacote event, Emitter<PacoteState> emit) async {
  try {
    await pacoteRepository.updatePacote(event.pacote);

    final existingTreinoIds = await pacoteTreinoRepository.getTreinoIdsByPacoteId(event.pacote.id!);
    final newTreinoIds = event.treinos.map((treino) => treino.id!).toList();

    for (var id in existingTreinoIds) {
      if (!newTreinoIds.contains(id)) {
        await pacoteTreinoRepository.removeTreinoFromPacote(event.pacote.id!, id);
      }
    }

    for (var id in newTreinoIds) {
      if (!existingTreinoIds.contains(id)) {
        await pacoteTreinoRepository.addTreinoToPacote(event.pacote.id!, id);
      }
    }

    add(LoadPacotes());
  } catch (e) {
    emit(PacoteError(e.toString()));
  }
}


  Future<void> _onDeletePacote(
      DeletePacote event, Emitter<PacoteState> emit) async {
    try {
      await pacoteRepository.deletePacote(event.id);
      add(LoadPacotes());
    } catch (e) {
      emit(PacoteError(e.toString()));
    }
  }
}
