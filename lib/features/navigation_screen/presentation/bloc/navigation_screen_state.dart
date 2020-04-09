import 'package:equatable/equatable.dart';

abstract class NavigationScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class RunDetails extends NavigationScreenState {}

class RunPlaced extends NavigationScreenState {}

class Login extends NavigationScreenState {}

class Home extends NavigationScreenState {}

class Settings extends NavigationScreenState {}
