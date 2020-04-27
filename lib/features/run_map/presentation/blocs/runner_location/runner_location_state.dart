import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunnerLocationState extends Equatable {
  const RunnerLocationState();

  @override
  List<Object> get props => [];
}

class RunnerLocationUninitialized extends RunnerLocationState {}

class RunnerLocationUpdateSuccess extends RunnerLocationState {
  final RunModel runModel;
  final LocationModel runnerLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const RunnerLocationUpdateSuccess({
    @required this.runModel,
    @required this.runnerLocation,
    @required this.polylines,
    @required this.markers,
  });

  @override
  List<Object> get props => [
    runModel,
    runnerLocation,
    polylines,
    markers,
  ];
}

class RunnerLocationUpdateFailure extends RunnerLocationState {
  final String message;

  const RunnerLocationUpdateFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
