import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class PlacePhotoEvent extends Equatable {
  const PlacePhotoEvent();

  @override
  List<Object> get props => [];
}

class PlacePhotoRequested extends PlacePhotoEvent {
  final PlaceEntity placeEntity;

  const PlacePhotoRequested({@required this.placeEntity});
}
