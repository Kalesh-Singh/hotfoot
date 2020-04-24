import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunnerLocationState extends Equatable {
  final RunModel runModel;
  final LocationModel runnerLocation;

  const RunnerLocationState({
    @required this.runModel,
    @required this.runnerLocation,
  });

  @override
  List<Object> get props => [runModel];
}

class RunnerLocationUninitialized extends RunnerLocationState {}

class RunnerLocationUpdateSuccess extends RunnerLocationState {
  const RunnerLocationUpdateSuccess({
    @required RunModel runModel,
    @required LocationModel runnerLocation,
  }) : super(
          runModel: runModel,
          runnerLocation: runnerLocation,
        );
}
