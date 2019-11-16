import 'package:flutter/material.dart';

class RunStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Status'),
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
