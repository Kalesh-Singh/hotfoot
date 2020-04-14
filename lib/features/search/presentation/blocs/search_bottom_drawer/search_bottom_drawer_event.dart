import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchBottomDrawerEvent extends Equatable {
  const SearchBottomDrawerEvent();

  @override
  List<Object> get props => [];
}

class SearchItemSelectedForDrawer extends SearchBottomDrawerEvent {
  final String placeId;

  const SearchItemSelectedForDrawer({@required this.placeId});
}
