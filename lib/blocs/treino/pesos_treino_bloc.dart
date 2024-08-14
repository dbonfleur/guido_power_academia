import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/treino_repository.dart';
import 'pesos_treino_event.dart';
import 'pesos_treino_state.dart';

class PesosTreinoBloc extends Bloc<PesosTreinoEvent, PesosTreinoState> {
  final TreinoRepository treinoRepository;

  PesosTreinoBloc(this.treinoRepository) : super(PesosTreinoInitial()) {
    on<LoadPesosTreino>(_onLoadPesosTreino);
    on<CreatePesosTreino>(_onCreatePesosTreino);
    on<UpdatePesosTreino>(_onUpdatePesosTreino);
    on<DeletePesosTreino>(_onDeletePesosTreino);
  }

  Future<void> _onLoadPesosTreino(LoadPesosTreino event, Emitter<PesosTreinoState> emit) async {
    emit(PesosTreinoLoading());
    try {
      final pesosTreino = await treinoRepository.getPesosTreinoByUserId(event.userId);
      emit(PesosTreinoLoaded(pesosTreino));
    } catch (e) {
      emit(PesosTreinoError(e.toString()));
    }
  }

  Future<void> _onCreatePesosTreino(CreatePesosTreino event, Emitter<PesosTreinoState> emit) async {
    try {
      await treinoRepository.createPesosTreino(event.pesosTreino);
      add(LoadPesosTreino(event.pesosTreino.userId));
    } catch (e) {
      emit(PesosTreinoError(e.toString()));
    }
  }

  Future<void> _onUpdatePesosTreino(UpdatePesosTreino event, Emitter<PesosTreinoState> emit) async {
    try {
      await treinoRepository.updatePesosTreino(event.pesosTreino);
      add(LoadPesosTreino(event.pesosTreino.userId));
    } catch (e) {
      emit(PesosTreinoError(e.toString()));
    }
  }

  Future<void> _onDeletePesosTreino(DeletePesosTreino event, Emitter<PesosTreinoState> emit) async {
    try {
      await treinoRepository.deletePesosTreino(event.id);
      add(LoadPesosTreino(event.id));
    } catch (e) {
      emit(PesosTreinoError(e.toString()));
    }
  }
}
