import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/treino_repository.dart';
import 'user_pacote_treino_event.dart';
import 'user_pacote_treino_state.dart';

class UserPacoteTreinoBloc extends Bloc<UserPacoteTreinoEvent, UserPacoteTreinoState> {
  final TreinoRepository treinoRepository;

  UserPacoteTreinoBloc(this.treinoRepository) : super(UserPacoteTreinoInitial()) {
    on<LoadUserPacotesTreino>(_onLoadUserPacotesTreino);
    on<CreateUserPacoteTreino>(_onCreateUserPacoteTreino);
    on<UpdateUserPacoteTreino>(_onUpdateUserPacoteTreino);
    on<DeleteUserPacoteTreino>(_onDeleteUserPacoteTreino);
  }

  Future<void> _onLoadUserPacotesTreino(LoadUserPacotesTreino event, Emitter<UserPacoteTreinoState> emit) async {
    emit(UserPacoteTreinoLoading());
    try {
      final userPacotesTreino = await treinoRepository.getAllUserPacotesTreino();
      emit(UserPacoteTreinoLoaded(userPacotesTreino));
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onCreateUserPacoteTreino(CreateUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await treinoRepository.createUserPacoteTreino(event.userPacoteTreino);
      add(LoadUserPacotesTreino());
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onUpdateUserPacoteTreino(UpdateUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await treinoRepository.updateUserPacoteTreino(event.userPacoteTreino);
      add(LoadUserPacotesTreino());
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onDeleteUserPacoteTreino(DeleteUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await treinoRepository.deleteUserPacoteTreino(event.id);
      add(LoadUserPacotesTreino());
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }
}
