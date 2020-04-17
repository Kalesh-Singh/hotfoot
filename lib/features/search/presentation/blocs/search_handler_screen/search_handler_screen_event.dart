import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchHandlerScreenEvent extends Equatable {
  const SearchHandlerScreenEvent();

  @override
  List<Object> get props => [];
}

class SearchBarPressed extends SearchHandlerScreenEvent {}

class SearchResultSelectedFromList extends SearchHandlerScreenEvent {
  final String placeId;

  const SearchResultSelectedFromList({@required this.placeId});
}

class BackButtonPressed extends SearchHandlerScreenEvent {}
