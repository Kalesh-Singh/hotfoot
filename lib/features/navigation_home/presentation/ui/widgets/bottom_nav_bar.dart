import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/core/style/style.dart';
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
        icon: FaIcon(FontAwesomeIcons.home),
        title: Text('Home', style: navBarStyle,),
      ),
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.solidStickyNote),
        title: Text('Runs', style: navBarStyle,),
      ),
    ];
  }

  List<BottomNavigationBarItem> _customerNavBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.home),
        title: Text('Home', style: navBarStyle,),
      ),
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.search),
        title: Text('Search', style: navBarStyle,),
      ),
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.solidStickyNote),
        title: Text('Runs', style: navBarStyle,),
      ),
    ];
  }
}
