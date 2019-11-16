import 'package:flutter/material.dart';

class RequestRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Request'),
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
      Navigator.pushNamed(context, '/run_status');
    },
    child: Text('Place Run Request'),
  );
}
