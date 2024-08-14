import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/treino_repository.dart';
import 'historico_treino_event.dart';
import 'historico_treino_state.dart';

class HistoricoTreinoBloc extends Bloc<HistoricoTreinoEvent, HistoricoTreinoState> {
  final TreinoRepository treinoRepository;

  HistoricoTreinoBloc(this.treinoRepository) : super(HistoricoTreinoInitial()) {
    on<LoadHistoricoTreino>(_onLoadHistoricoTreino);
    on<CreateHistoricoTreino>(_onCreateHistoricoTreino);
  }

  Future<void> _onLoadHistoricoTreino(LoadHistoricoTreino event, Emitter<HistoricoTreinoState> emit) async {
    emit(HistoricoTreinoLoading());
    try {
      final historicoTreino = await treinoRepository.getHistoricoTreinoByUserPacoteTreinoId(event.userPacoteTreinoId);
      emit(HistoricoTreinoLoaded(historicoTreino));
    } catch (e) {
      emit(HistoricoTreinoError(e.toString()));
    }
  }

  Future<void> _onCreateHistoricoTreino(CreateHistoricoTreino event, Emitter<HistoricoTreinoState> emit) async {
    try {
      await treinoRepository.createHistoricoTreino(event.historicoTreino);
      add(LoadHistoricoTreino(event.historicoTreino.userPacoteTreino.id!));
    } catch (e) {
      emit(HistoricoTreinoError(e.toString()));
    }
  }
}
