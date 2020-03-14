import 'package:flutter/material.dart';
import 'package:hotfoot/features/registration/presentation/ui/screen/registration_screen.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
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
