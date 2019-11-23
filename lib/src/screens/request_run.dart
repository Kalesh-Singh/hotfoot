import 'package:flutter/material.dart';
import '../navigation/nav_bar.dart';

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
      bottomNavigationBar: NavBar.build(),
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
