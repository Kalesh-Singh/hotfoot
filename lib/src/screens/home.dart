import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          profileButton(context),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            submitButton(context),
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
  return FlatButton(
    textColor: Colors.white,
    onPressed: () { 
      Navigator.pushNamed(context, '/profile'); 
      },
    child: Icon(Icons.account_circle, size: 50.0,),
    shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
    );
}
