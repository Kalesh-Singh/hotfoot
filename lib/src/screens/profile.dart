import 'package:flutter/material.dart';
import '../navigation/nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/src/blocs/authentication_bloc/authentication_bloc.dart';


class ProfileScreen extends StatelessWidget {
  final String name;
  ProfileScreen({Key key, @required this.name}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 70.0),
            Column(
              children: <Widget>[
                Icon(Icons.account_circle,size: 130.0,),
              ],
            ),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                '$name',
                style: TextStyle(fontSize: 20),
              )
            ),
            SizedBox(height: 24.0),
            Center(child: signoutButton(context),)
          ],
        ),
      ),
      bottomNavigationBar: NavBar.build(),
    );
  }
}

Widget signoutButton(context) {
  return RaisedButton(
    onPressed: () {
      // Log out of application
      BlocProvider.of<AuthenticationBloc>(context).add(
        LoggedOut(),
        );
      Navigator.pushNamed(context, '/');
    },
    color: Colors.amber,
    child: Text('Signout'),
  );
}