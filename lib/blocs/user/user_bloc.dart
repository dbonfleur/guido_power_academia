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
    on<UpdateUserName>(_onUpdateUserName);
    on<UpdateUserDateOfBirth>(_onUpdateUserDateOfBirth);
    on<UpdateUserPaymentMethod>(_onUpdateUserPaymentMethod);
    on<UpdateUserImage>(_onUpdateUserImage);
    on<UpdateUserPassword>(_onUpdateUserPassword);
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
        emit(const UserError('Usuário não encontrado'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserName(UpdateUserName event, Emitter<UserState> emit) async {
  if (state is UserLoaded) {
    final updatedUser = (state as UserLoaded).user.copyWithUserName(fullName: event.fullName);
    await userRepository.updateUser(updatedUser);
    emit(UserLoaded(updatedUser));
  }
}

Future<void> _onUpdateUserDateOfBirth(UpdateUserDateOfBirth event, Emitter<UserState> emit) async {
  if (state is UserLoaded) {
    final updatedUser = (state as UserLoaded).user.copyWithDateOfBirth(dateOfBirth: event.dateOfBirth);
    await userRepository.updateUser(updatedUser);
    emit(UserLoaded(updatedUser));
  }
}

Future<void> _onUpdateUserPaymentMethod(UpdateUserPaymentMethod event, Emitter<UserState> emit) async {
  if (state is UserLoaded) {
    final updatedUser = (state as UserLoaded).user.copyWithPaymentMethod(paymentMethod: event.paymentMethod);
    await userRepository.updateUser(updatedUser);
    emit(UserLoaded(updatedUser));
  }
}

Future<void> _onUpdateUserImage(UpdateUserImage event, Emitter<UserState> emit) async {
  if (state is UserLoaded) {
    final user = (state as UserLoaded).user;
    final updatedUser = user.copyWithUserImage(imageUrl: event.imageUrl);
    
    await userRepository.updateUser(updatedUser);
    emit(UserLoaded(updatedUser));
  }
}

Future<void> _onUpdateUserPassword(UpdateUserPassword event, Emitter<UserState> emit) async {
  if (state is UserLoaded) {
    final user = (state as UserLoaded).user;
    final hashedOldPassword = User.hashPassword(event.oldPassword);
    
    if (user.password == hashedOldPassword) {
      final updatedUser = user.copyWithPassword(password: User.hashPassword(event.newPassword));
      await userRepository.updateUser(updatedUser);
      emit(UserLoaded(updatedUser));
    } else {
      emit(const UserError('Senha antiga não confere'));
    }
  }
}

}
