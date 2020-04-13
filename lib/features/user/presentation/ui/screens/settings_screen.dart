import 'package:flutter/material.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_type_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Authenticated authState =
        BlocProvider.of<NavigationAuthBloc>(context).state;
    final user = authState.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome()),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 70.0),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 130.0,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Center(
                  child: Text(
                '$user',
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(height: 24),
              UserTypeWidget(),
              SizedBox(height: 24.0),
              Center(
                child: signOutButton(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget signOutButton(context) {
  return RaisedButton(
    onPressed: () {
      // Log out of application
      BlocProvider.of<NavigationAuthBloc>(context).add(
        LoggedOut(),
      );
    },
    color: Colors.amber,
    child: Text('Signout'),
  );
}
