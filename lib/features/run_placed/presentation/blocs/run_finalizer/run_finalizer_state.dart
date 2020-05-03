import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RunFinalizerState extends Equatable {
  const RunFinalizerState();

  @override
  List<Object> get props => [];
}

class RunFinalizerUninitialized extends RunFinalizerState {}

class RunFinalizerFundsUpdated extends RunFinalizerState {}

class RunFinalizerDone extends RunFinalizerState {}

class RunFinalizerFailure extends RunFinalizerState {
  final String message;

  const RunFinalizerFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
