import 'package:equatable/equatable.dart';

abstract class PlacesIdsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlacesRequested extends PlacesIdsEvent {}
