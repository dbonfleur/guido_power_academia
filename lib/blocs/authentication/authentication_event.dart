part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthenticationEvent {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginRequested(this.username, this.password, {this.rememberMe = false});

  @override
  List<Object> get props => [username, password, rememberMe];
}

class CheckLoginStatus extends AuthenticationEvent {}

class LogoutRequested extends AuthenticationEvent {}
