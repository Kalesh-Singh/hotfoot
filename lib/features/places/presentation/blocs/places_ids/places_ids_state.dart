import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PlacesIdsState extends Equatable {
  const PlacesIdsState();

  @override
  List<Object> get props => [];
}

class PlacesIdsUninitialized extends PlacesIdsState {}

class PlacesIdsLoadSuccess extends PlacesIdsState {
  final List<String> placesIds;

  const PlacesIdsLoadSuccess({@required this.placesIds});

  @override
  List<Object> get props => [placesIds];
}

class PlacesIdsLoadFailure extends PlacesIdsState {
  final String message;

  const PlacesIdsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
