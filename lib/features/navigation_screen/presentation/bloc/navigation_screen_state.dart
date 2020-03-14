import 'package:equatable/equatable.dart';

abstract class NavigationScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestRun extends NavigationScreenState {}

class Login extends NavigationScreenState {}

class Home extends NavigationScreenState {}

class Settings extends NavigationScreenState {}
