import 'package:flutter_bloc/flutter_bloc.dart';
import 'pesos_treino_event.dart';
import 'pesos_treino_state.dart';
import '../../repositories/pesos_treino_repository.dart';

class PesosTreinoBloc extends Bloc<PesosTreinoEvent, PesosTreinoState> {
  final PesosTreinoRepository treinoRepository;

  PesosTreinoBloc(this.treinoRepository) : super(PesosTreinoInitial()) {
    on<LoadPesosTreino>(_onLoadPesosTreino);
    on<AddPesosTreino>(_onAddPesosTreino);
    on<UpdatePesosTreino>(_onUpdatePesosTreino);
  }

  Future<void> _onLoadPesosTreino(LoadPesosTreino event, Emitter<PesosTreinoState> emit) async {
    emit(PesosTreinoLoading());
    try {
      final pesosTreinos = await treinoRepository.getPesosTreinoByUserId(event.userId);
      emit(PesosTreinoLoaded(pesosTreinos));
    } catch (e) {
      emit(PesosTreinoError(e.toString()));
    }
  }

  Future<void> _onAddPesosTreino(AddPesosTreino event, Emitter<PesosTreinoState> emit) async {
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
}
