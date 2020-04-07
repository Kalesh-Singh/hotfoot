import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class CurrentPlaceRequested extends LocationEvent {}

class PlaceQueried extends LocationEvent {
  final String query;

  const PlaceQueried({@required this.query});

  @override
  List<Object> get props => [query];
}
