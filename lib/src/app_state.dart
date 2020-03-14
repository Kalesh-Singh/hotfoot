import 'package:flutter/material.dart';
import 'blocs/navigation_bloc.dart';
import 'screens/home.dart';
import 'screens/request_run.dart';
import 'screens/profile.dart';

// Need some reworking here
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
        child: StreamBuilder<Navigation>(
        stream: navBloc.navigationStream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case Navigation.HOME:
              return Home();
            case Navigation.RUN:
              return RequestRunTab();
            case Navigation.ACCOUNT:
              return ProfileTab(name: 'Ruel Gordon',);
            default:
              return Home();
          }
        },
      ),
    );
  }
}
