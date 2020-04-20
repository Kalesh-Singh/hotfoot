import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchHandlerScreenState extends Equatable {
  const SearchHandlerScreenState();

  @override
  List<Object> get props => [];
}

class SearchHandlerScreenUninitialized extends SearchHandlerScreenState {}

class SearchHandlerScreenOpened extends SearchHandlerScreenState {}

class SearchHandlerScreenReturned extends SearchHandlerScreenState {
  final String placeId;

  const SearchHandlerScreenReturned({@required this.placeId});

  @override
  List<Object> get props => [placeId];
}
