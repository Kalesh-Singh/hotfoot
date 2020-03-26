import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AcceptDeliveryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme (
      minWidth: 140.0,
      height: 40.0, 
    child: RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: FaIcon(FontAwesomeIcons.check, color: Colors.white),
      onPressed: () {
        print("Accept delivery button is pressed");
      },
      label: Text('Accept Delivery', style: TextStyle(color: Colors.white)),
      color: Colors.lightBlueAccent,
    )
    );
  }
}