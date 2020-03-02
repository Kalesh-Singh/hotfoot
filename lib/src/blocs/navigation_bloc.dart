import 'package:rxdart/rxdart.dart';

enum Navigation { HOME, RUN, ACCOUNT }

class NavigationBloc {
  final BehaviorSubject<Navigation> _navigationController =
      BehaviorSubject.seeded(Navigation.HOME);

  Stream<Navigation> get navigationStream => _navigationController.stream;

  Function(Navigation) get changeNavigationIndex => _navigationController.sink.add;

  int get currentNavigationIndex => _navigationController.value.index;

  void dispose() => _navigationController?.close();
}

final NavigationBloc navBloc = new NavigationBloc();
