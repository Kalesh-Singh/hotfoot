import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DrawerContentsEvent extends Equatable {
  const DrawerContentsEvent();

  @override
  List<Object> get props => [];
}

class SearchItemSelectedForDrawer extends DrawerContentsEvent {
  final String placeId;

  const SearchItemSelectedForDrawer({@required this.placeId});
}
