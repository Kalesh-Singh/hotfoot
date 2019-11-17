import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
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
                //CircleAvatar(
                 // minRadius: 90.0, 
                Icon(Icons.account_circle,size: 130.0,),
                  //)
              ],
            ),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                'U S E R N A M E',
                style: TextStyle(fontSize: 20),
              )
            ),
            SizedBox(height: 24.0),
            Center(child: signoutButton(context),)
          ],
        ),
      ),
    );
  }
}

Widget signoutButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/');
    },
    color: Colors.amber,
    child: Text('Signout'),
  );
}