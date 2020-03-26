import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CancelDeliveryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme (
      minWidth: 140.0,
      height: 40.0, 
    child: RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: FaIcon(FontAwesomeIcons.windowClose, color: Colors.white),
      onPressed: () {
        print("Cancel delivery button is pressed");
      },
      label: Text('Cancel Delivery', style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
    )
    );
  }
}