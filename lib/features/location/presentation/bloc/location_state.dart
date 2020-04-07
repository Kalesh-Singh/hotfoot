import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class CurrentPlaceUninitialized extends LocationState {}

class CurrentPlaceLoadSuccess extends LocationState {
  final PlaceEntity placeEntity;

  const CurrentPlaceLoadSuccess({@required this.placeEntity});

  @override
  List<Object> get props => [placeEntity];
}

class CurrentPlaceLoadFailure extends LocationState {
  final String message;

  const CurrentPlaceLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class QueriedPlaceLoadSuccess extends LocationState {
  final PlaceEntity placeEntity;

  const QueriedPlaceLoadSuccess({@required this.placeEntity});

  @override
  List<Object> get props => [placeEntity];
}

class QueriedPlaceLoadFailure extends LocationState {
  final String message;

  const QueriedPlaceLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
