import 'package:flutter/material.dart';
import '../blocs/navigation_bloc.dart';

class NavBar {
  static Widget build() {
    return Container(
      child: StreamBuilder(
        stream: navBloc.navigationStream,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_run),
                title: Text('Run'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text('Account'),
              ),
            ],
            currentIndex: navBloc.currentNavigationIndex,
            onTap: (index) =>
                navBloc.changeNavigationIndex(Navigation.values[index]),
          );
        },
      ),
    );
  }
}
