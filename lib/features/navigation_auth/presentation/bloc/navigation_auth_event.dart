import 'package:equatable/equatable.dart';

abstract class NavigationAuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends NavigationAuthEvent {}

class LoggedIn extends NavigationAuthEvent {}

class LoggedOut extends NavigationAuthEvent {}
