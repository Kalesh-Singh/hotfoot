import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_state.dart';

class SearchHandlerScreenBloc
    extends Bloc<SearchHandlerScreenEvent, SearchHandlerScreenState> {
  @override
  SearchHandlerScreenState get initialState =>
      SearchHandlerScreenUninitialized();

  @override
  Stream<SearchHandlerScreenState> mapEventToState(
      SearchHandlerScreenEvent event) async* {
    if (event is SearchBarPressed) {
      yield SearchHandlerScreenOpened();
    } else if (event is SearchResultSelectedFromList) {
      yield SearchHandlerScreenReturned(placeId: event.placeId);
    } else {
      yield SearchHandlerScreenUninitialized();
    }
  }
}
