import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/order_details_popup.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/user_details_popup.dart';

class MoreInfoSpeedDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      animationSpeed: 250,
      marginRight: 25.0,
      marginBottom: 30.0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.assignment, color: Colors.white),
          onTap: () => showDialog(
              context: context,
              builder: (context) {
                return OrderDetailsPopUp();
              }),
          label: 'Order Details',
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.redAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.directions_run, color: Colors.white),
          onTap: () => showDialog(
              context: context,
              builder: (context) {
                return UserDetailsPopUp();
              }),
          label: 'Runner/Customer Details',
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.redAccent,
        ),
      ],
    );
  }
}
