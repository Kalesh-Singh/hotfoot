import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class PlaceDetailsState extends Equatable {
  const PlaceDetailsState();

  @override
  List<Object> get props => [];
}

class PlaceDetailsUninitialized extends PlaceDetailsState {}

class PlaceDetailsLoadSuccess extends PlaceDetailsState {
  final PlaceEntity placeEntity;

  const PlaceDetailsLoadSuccess({@required this.placeEntity});

  @override
  List<Object> get props => [placeEntity];
}

class PlaceDetailsLoadFailure extends PlaceDetailsState {
  final String message;

  const PlaceDetailsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
