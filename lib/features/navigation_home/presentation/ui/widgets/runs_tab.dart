import 'package:flutter/material.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Text('Past [and Current] Orders'),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
