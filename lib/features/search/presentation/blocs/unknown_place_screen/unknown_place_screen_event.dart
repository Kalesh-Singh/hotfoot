import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

abstract class UnknownPlaceScreenEvent extends Equatable {
  const UnknownPlaceScreenEvent();

  @override
  List<Object> get props => [];
}

class ContinueOrderButtonPressed extends UnknownPlaceScreenEvent {
  final LatLng latLng;
  final String placeName;

  const ContinueOrderButtonPressed(
      {@required this.latLng, @required this.placeName});
}
