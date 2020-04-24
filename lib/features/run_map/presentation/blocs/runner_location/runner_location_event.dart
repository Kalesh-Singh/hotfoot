import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunnerLocationEvent extends Equatable {
  final RunModel runModel;
  final LocationModel runnerLocation;
  final GoogleMapController mapController;

  const RunnerLocationEvent({
    @required this.runModel,
    @required this.runnerLocation,
    @required this.mapController,
  });

  @override
  List<Object> get props => [runModel, runnerLocation];
}

class RunnerLocationUpdated extends RunnerLocationEvent {
  const RunnerLocationUpdated({
    @required RunModel runModel,
    @required LocationModel runnerLocation,
    @required GoogleMapController mapController,
  }) : super(
          runModel: runModel,
          runnerLocation: runnerLocation,
          mapController: mapController,
        );
}
