import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_event.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_state.dart';
import 'package:meta/meta.dart';

class NavigationHomeBloc
    extends Bloc<NavigationHomeEvent, NavigationHomeState> {
  @override
  NavigationHomeState get initialState => HomeIconTab();

  @override
  Stream<NavigationHomeState> mapEventToState(
    NavigationHomeEvent event,
  ) async* {
    if (event is HomeIconPressed) {
      yield HomeIconTab();
    } else if (event is SearchIconPressed) {
      yield SearchIconTab();
    } else if (event is OrdersIconPressed) {
      yield OrdersIconTab();
    }
  }

  int getCurrentNavigationIndex({@required bool isRunner}) {
    if (isRunner) {
      switch (state.runtimeType) {
        case HomeIconTab:
          return 0;
        case OrdersIconTab:
          return 1;
        default:
          return 0;
      }
    } else {
      switch (state.runtimeType) {
        case HomeIconTab:
          return 0;
        case SearchIconTab:
          return 1;
        case OrdersIconTab:
          return 2;
        default:
          return 0;
      }
    }
  }

  void changeNavigationIndex({
    @required int index,
    @required bool isRunner,
  }) {
    if (isRunner) {
      switch (index) {
        case 0:
          add(HomeIconPressed());
          break;
        case 1:
          add(OrdersIconPressed());
          break;
        default:
          add(HomeIconPressed());
      }
    } else {
      switch (index) {
        case 0:
          add(HomeIconPressed());
          break;
        case 1:
          add(SearchIconPressed());
          break;
        case 2:
          add(OrdersIconPressed());
          break;
        default:
          add(HomeIconPressed());
      }
    }
  }
}
