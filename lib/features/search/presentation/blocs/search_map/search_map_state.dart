import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';

abstract class SearchMapState extends Equatable {
  const SearchMapState();

  @override
  List<Object> get props => [];
}

class SearchMapUninitialized extends SearchMapState {}

class SearchMapLoaded extends SearchMapState {
  final LocationEntity locationEntity;

  const SearchMapLoaded({@required this.locationEntity});

  @override
  List<Object> get props => [locationEntity];
}

class SearchMapFailure extends SearchMapState {
  final String message;

  const SearchMapFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
