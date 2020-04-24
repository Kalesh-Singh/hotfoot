import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunUpdateState extends Equatable {
  final RunModel runModel;

  const RunUpdateState({@required this.runModel});

  @override
  List<Object> get props => [runModel];
}

class RunUpdateUninitialized extends RunUpdateState {}

class RunUpdateLoadSuccess extends RunUpdateState {
  const RunUpdateLoadSuccess({@required RunModel runModel})
      : super(runModel: runModel);
}
