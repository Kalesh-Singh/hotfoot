import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_state.dart';

class SearchBottomDrawerBloc
    extends Bloc<SearchBottomDrawerEvent, SearchBottomDrawerState> {
  @override
  SearchBottomDrawerState get initialState => SearchBottomDrawerClosed();

  @override
  Stream<SearchBottomDrawerState> mapEventToState(
      SearchBottomDrawerEvent event) async* {
    if (event is SearchBottomDrawerSwipedUp) {
      yield SearchBottomDrawerOpened();
    } else if (event is SearchBottomDrawerSwipedDown) {
      yield SearchBottomDrawerClosed();
    }
  }
}
