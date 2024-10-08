import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_pacote_treino_repository.dart';
import 'user_pacote_treino_event.dart';
import 'user_pacote_treino_state.dart';

class UserPacoteTreinoBloc extends Bloc<UserPacoteTreinoEvent, UserPacoteTreinoState> {
  final UserPacoteTreinoRepository userPacoteTreinoRepo;

  UserPacoteTreinoBloc(this.userPacoteTreinoRepo) : super(UserPacoteTreinoInitial()) {
    on<LoadUserPacotesTreino>(_onLoadUserPacotesTreino);
    on<CreateUserPacoteTreino>(_onCreateUserPacoteTreino);
    on<UpdateUserPacoteTreino>(_onUpdateUserPacoteTreino);
    on<DeleteUserPacoteTreino>(_onDeleteUserPacoteTreino);
  }

  Future<void> _onLoadUserPacotesTreino(LoadUserPacotesTreino event, Emitter<UserPacoteTreinoState> emit) async {
    emit(UserPacoteTreinoLoading());
    try {
      final pacotesTreino = await userPacoteTreinoRepo.getPacoteTreinoIdsByUser(event.userId);
      emit(UserPacoteTreinoLoaded(pacotesTreino.map((pt) => pt.pacoteId).toList(), pacotesTreino));
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onCreateUserPacoteTreino(CreateUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await userPacoteTreinoRepo.createUserPacoteTreino(event.userPacoteTreino);
      add(LoadUserPacotesTreino(event.userPacoteTreino.alunoId));
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onUpdateUserPacoteTreino(UpdateUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await userPacoteTreinoRepo.updateUserPacoteTreino(event.userPacoteTreino);
      add(LoadUserPacotesTreino(event.userPacoteTreino.alunoId)); 
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }

  Future<void> _onDeleteUserPacoteTreino(DeleteUserPacoteTreino event, Emitter<UserPacoteTreinoState> emit) async {
    try {
      await userPacoteTreinoRepo.deleteUserPacoteTreino(event.id);
      emit(UserPacoteTreinoInitial());
    } catch (e) {
      emit(UserPacoteTreinoError(e.toString()));
    }
  }
}
