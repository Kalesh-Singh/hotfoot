import 'package:flutter/material.dart';

class PlaceRunBotton extends StatelessWidget {
  final VoidCallback _onPressed;

  PlaceRunBotton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Place Run'),
    );
  }
}
