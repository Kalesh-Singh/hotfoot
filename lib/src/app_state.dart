import 'package:flutter/material.dart';
import 'blocs/navigation_bloc.dart';
import 'screens/home.dart';
import 'screens/request_run.dart';
import 'screens/profile.dart';

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
        child: StreamBuilder<Navigation>(
        stream: navBloc.navigationStream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case Navigation.HOME:
              return HomeScreen();
            case Navigation.RUN:
              return RequestRunScreen();
            case Navigation.ACCOUNT:
              return ProfileScreen();
            default:
              return HomeScreen();
          }
        },
      ),
    );
  }
}
