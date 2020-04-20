import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationHomeBloc = BlocProvider.of<NavigationHomeBloc>(context);
    final userTypeBloc = BlocProvider.of<UserTypeBloc>(context);
    final bool isRunner = userTypeBloc.state is RunnerUserType;
    print('ISRUNNER: $isRunner');

    return Container(
      child: BottomNavigationBar(
        items: isRunner ? _runnerNavBarItems() : _customerNavBarItems(),
        currentIndex:
            navigationHomeBloc.getCurrentNavigationIndex(isRunner: isRunner),
        onTap: (index) => navigationHomeBloc.changeNavigationIndex(
          index: index,
          isRunner: isRunner,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _runnerNavBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        title: Text('Runs'),
      ),
    ];
  }

  List<BottomNavigationBarItem> _customerNavBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        title: Text('Runs'),
      ),
    ];
  }
}
