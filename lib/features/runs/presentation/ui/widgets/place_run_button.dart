import 'package:flutter/material.dart';
import 'package:hotfoot/src/utils/style.dart';

class PlaceRunBotton extends StatelessWidget {
  final VoidCallback _onPressed;

  PlaceRunBotton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(0.0, 12.5, 0.0, 12.5),
      color: Colors.red[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Place Run',
      textAlign: TextAlign.center,
        style: style.copyWith(
          color: Colors.black, 
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        ),
      ),
    );
  }
}
