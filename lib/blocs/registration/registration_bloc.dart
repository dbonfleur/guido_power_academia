import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository userRepository;

  RegistrationBloc(this.userRepository) : super(RegistrationInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUser event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    try {
      String? imageBase64;
      if (event.imageUrl != null) {
        final bytes = File(event.imageUrl!).readAsBytesSync();
        imageBase64 = base64Encode(bytes);
      }

      final user = User(
        username: event.username,
        fullName: event.fullName,
        dateOfBirth: event.dateOfBirth,
        email: event.email,
        password: User.hashPassword(event.password),
        paymentMethod: event.paymentMethod,
        contractDuration: event.contractDuration,
        accountType: event.accountType,
        imageUrl: imageBase64, 
      );
      await userRepository.createUser(user);
      emit(RegistrationSuccess());
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
