import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';
import '../user/user_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository) : super(AuthenticationInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final user = await userRepository.authenticate(event.username, event.password);
      if (user != null) {
        if (event.rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', user.username);
        }
        emit(AuthenticationSuccess(user));

        BlocProvider.of<UserBloc>(event.context).add(LoadUser(user.id!));
      } else {
        emit(const AuthenticationFailure('Usuário ou senha inválidos'));
      }
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }

  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<AuthenticationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      final username = prefs.getString('username');
      if (username != null) {
        final user = await userRepository.getUserByUsername(username);
        if (user != null) {
          emit(AuthenticationSuccess(user));
        } else {
          emit(AuthenticationInitial());
        }
      } else {
        emit(AuthenticationInitial());
      }
    } else {
      emit(AuthenticationInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(AuthenticationInitial());
  }
}
