import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';

abstract class SearchMapState extends Equatable {
  const SearchMapState();

  @override
  List<Object> get props => [];
}

class SearchMapStateUninitialized extends SearchMapState {}

class SearchMapStateLoaded extends SearchMapState {
  final LocationEntity locationEntity;

  const SearchMapStateLoaded({@required this.locationEntity});

  @override
  List<Object> get props => [locationEntity];
}

class SearchMapStateFailure extends SearchMapState {
  final String message;

  const SearchMapStateFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
