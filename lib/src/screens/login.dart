import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/asteroid.png'),
                  SizedBox(height: 20.0),
                  Text('Hotfoot'),
                ],
              ),
              SizedBox(height: 65.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                ),
              ),
              SizedBox(height: 16.0),
              // Password
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                ),
                obscureText: true,
              ),
              SizedBox(height: 15.0),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10), 
                    onPressed: () {
                    },
                  ),
                  Center(child: submitButton(context))
                ],
              )
            ],
          ),
        )
    );
  }
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/home');
    },
    child: Text('Login'),
    color: Colors.amber,
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10)
  );
}
