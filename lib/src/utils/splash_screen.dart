import 'package:flutter/material.dart';

// Simple screen to be rendered while the bloc determines
// if the user is logged in
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}