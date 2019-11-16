import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            submitButton(context),
            profileButton(context),
          ],
        ),
      ),
    );
  }
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/request_run');
    },
    child: Text('Request Run'),
  );
}

Widget profileButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/profile');
    },
    child: Text('Profile'),
  );
}
