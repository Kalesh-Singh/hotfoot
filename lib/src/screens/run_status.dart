import 'package:flutter/material.dart';
import 'package:hotfoot/src/utils/atlas.dart';

class RunStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: const Text('Run Status'),
        ),
        body: Center(
          child: Atlas(),
        ));
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
