import 'package:flutter/material.dart';
// For font styling across the app
import 'package:hotfoot/src/utils/style.dart';
class RegistrationButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegistrationButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(0.0, 12.5, 0.0, 12.5),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Register',
        textAlign: TextAlign.center,
        style: style.copyWith(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        ),
      ),
    );
  }
}
