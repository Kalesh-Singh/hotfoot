import 'package:equatable/equatable.dart';

abstract class AuthenticationNavEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationNavEvent {}

class LoggedIn extends AuthenticationNavEvent {}

class LoggedOut extends AuthenticationNavEvent {}