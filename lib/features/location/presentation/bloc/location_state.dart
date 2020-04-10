import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationUninitialized extends LocationState {}

class CurrentPlaceLoadSuccess extends LocationState {
  final PlaceModel placeModel;

  const CurrentPlaceLoadSuccess({@required this.placeModel});

  @override
  List<Object> get props => [placeModel];
}

class CurrentPlaceLoadFailure extends LocationState {
  final String message;

  const CurrentPlaceLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class QueriedPlaceLoadSuccess extends LocationState {
  final PlaceModel placeModel;

  const QueriedPlaceLoadSuccess({@required this.placeModel});

  @override
  List<Object> get props => [placeModel];
}

class QueriedPlaceLoadFailure extends LocationState {
  final String message;

  const QueriedPlaceLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
