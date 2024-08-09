import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getUserById(event.userId);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(const UserError('User not found'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
