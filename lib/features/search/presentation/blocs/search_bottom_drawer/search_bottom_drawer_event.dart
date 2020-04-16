import 'package:equatable/equatable.dart';

abstract class SearchBottomDrawerEvent extends Equatable {
  const SearchBottomDrawerEvent();

  @override
  List<Object> get props => [];
}

class SearchBottomDrawerSwipedUp extends SearchBottomDrawerEvent {}

class SearchBottomDrawerSwipedDown extends SearchBottomDrawerEvent {}
