import 'package:flutter/material.dart';
import 'package:hotfoot/features/registration/presentation/ui/screen/registration_screen.dart';
import 'package:hotfoot/src/utils/style.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        'Create an Account',
        style: style.copyWith(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegistrationScreen();
          }),
        );
      },
    );
  }
}
