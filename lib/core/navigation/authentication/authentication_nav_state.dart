import 'package:equatable/equatable.dart';

abstract class AuthenticationNavState extends Equatable {
  const AuthenticationNavState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationNavState {}

class Authenticated extends AuthenticationNavState {
  final String displayName;

  const Authenticated(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthenticationNavState {}