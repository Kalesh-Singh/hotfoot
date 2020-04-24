import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class PlaceDetailsEvent extends Equatable {
  const PlaceDetailsEvent();

  @override
  List<Object> get props => [];
}

class PlaceDetailsRequested extends PlaceDetailsEvent {
  final String placeId;

  const PlaceDetailsRequested({@required this.placeId});
}

class CustomPlaceDetailsReceived extends PlaceDetailsEvent {
  final PlaceEntity placeEntity;

  const CustomPlaceDetailsReceived({@required this.placeEntity});
}
