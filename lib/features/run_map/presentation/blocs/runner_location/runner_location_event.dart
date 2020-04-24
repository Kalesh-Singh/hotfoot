import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunnerLocationEvent extends Equatable {
  final RunModel runModel;
  final LocationModel runnerLocation;

  const RunnerLocationEvent({
    @required this.runModel,
    @required this.runnerLocation,
  });

  @override
  List<Object> get props => [runModel, runnerLocation];
}

class RunnerLocationUpdated extends RunnerLocationEvent {
  const RunnerLocationUpdated({
    @required RunModel runModel,
    @required LocationModel runnerLocation,
  }) : super(
          runModel: runModel,
          runnerLocation: runnerLocation,
        );
}
