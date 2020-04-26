import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class RunnerLocationEvent extends Equatable {
  final RunModel runModel;
  final LocationModel runnerLocation;
  final UserType userType;
  final GoogleMapController mapController;

  const RunnerLocationEvent({
    @required this.runModel,
    @required this.runnerLocation,
    @required this.userType,
    @required this.mapController,
  });

  @override
  List<Object> get props => [runModel, runnerLocation, userType];
}

class RunnerLocationUpdated extends RunnerLocationEvent {
  const RunnerLocationUpdated({
    @required RunModel runModel,
    @required LocationModel runnerLocation,
    @required UserType userType,
    @required GoogleMapController mapController,
  }) : super(
          runModel: runModel,
          runnerLocation: runnerLocation,
          userType: userType,
          mapController: mapController,
        );
}
