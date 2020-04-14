import 'package:equatable/equatable.dart';

abstract class SearchBottomDrawerState extends Equatable {
  const SearchBottomDrawerState();

  @override
  List<Object> get props => [];
}

class SearchBottomDrawerOpened extends SearchBottomDrawerState {}

class SearchBottomDrawerClosed extends SearchBottomDrawerState {}
