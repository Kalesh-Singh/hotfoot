import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:meta/meta.dart';

abstract class RunDetailsState extends Equatable {
  const RunDetailsState();

  @override
  List<Object> get props => [];
}

class RunDetailsUninitialized extends RunDetailsState {}

class RunDetailsLoadSuccess extends RunDetailsState {
  final RunEntity runEntity;

  const RunDetailsLoadSuccess({@required this.runEntity});

  @override
  List<Object> get props => [runEntity];
}

class RunDetailsLoadFailure extends RunDetailsState {
  final String message;

  const RunDetailsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

