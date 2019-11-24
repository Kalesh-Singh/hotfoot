import 'package:flutter/material.dart';
import '../navigation/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Text('List Nearby Places'),
      bottomNavigationBar: NavBar.build(),
    );
  }
}
