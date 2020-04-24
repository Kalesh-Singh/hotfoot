import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AcceptRunState extends Equatable {
  const AcceptRunState();

  @override
  List<Object> get props => [];
}

class AcceptRunUninitialized extends AcceptRunState {}

class AcceptRunSuccess extends AcceptRunState {}

class AcceptRunFailure extends AcceptRunState {
  final String message;

  const AcceptRunFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
