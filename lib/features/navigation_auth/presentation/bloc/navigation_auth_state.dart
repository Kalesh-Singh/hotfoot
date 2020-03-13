import 'package:equatable/equatable.dart';

abstract class NavigationAuthState extends Equatable {
  const NavigationAuthState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends NavigationAuthState {}

class Authenticated extends NavigationAuthState {
  final String displayName;

  const Authenticated(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends NavigationAuthState {}
