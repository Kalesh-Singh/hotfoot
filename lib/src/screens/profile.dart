import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: submitButton(context),
      ),
    );
  }
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/home');
    },
    child: Text('Home'),
  );
}
