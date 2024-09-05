import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/mural_repository.dart';
import 'mural_event.dart';
import 'mural_state.dart';

class MuralBloc extends Bloc<MuralEvent, MuralState> {
  final MuralRepository muralRepo;

  MuralBloc({required this.muralRepo}) : super(MuralLoading()) {
    on<LoadMurals>(_onLoadMural);
    on<AddMural>(_onAddMural);
    on<UpdateMural>(_onUpdateMural);
    on<DeleteMural>(_onDeleteMural);
  }

  Future<void> _onLoadMural(LoadMurals event, Emitter<MuralState> emit) async {
    emit(MuralLoading());
    try {
      final murals = await muralRepo.getAllMurals();
      emit(MuralLoaded(murals: murals));
    } catch (e) {
      emit(MuralError('Erro ao carregar mural: ${e.toString()}'));
    }
  }

  Future<void> _onAddMural(AddMural event, Emitter<MuralState> emit) async {
    try {
      await muralRepo.insertMural(event.mural);
      final murals = await muralRepo.getAllMurals();
      emit(MuralLoaded(murals: murals));
    } catch (e) {
      emit(MuralError('Erro ao adicionar mural: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMural(UpdateMural event, Emitter<MuralState> emit) async {
    try {
      await muralRepo.updateMural(event.mural);
      final murals = await muralRepo.getAllMurals();
      emit(MuralLoaded(murals: murals));
    } catch (e) {
      emit(MuralError('Erro ao atualizar mural: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMural(DeleteMural event, Emitter<MuralState> emit) async {
    try {
      await muralRepo.deleteMural(event.muralId);
      final murals = await muralRepo.getAllMurals();
      emit(MuralLoaded(murals: murals));
    } catch (e) {
      emit(MuralError('Erro ao deletar mural: ${e.toString()}'));
    }
  }
}
