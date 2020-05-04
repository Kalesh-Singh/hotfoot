import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:hotfoot/features/registration/presentation/ui/widgets/registration_form.dart';
import 'package:hotfoot/injection_container.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register',
        style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: BlocProvider<RegistrationBloc>(
          create: (context) => sl<RegistrationBloc>(),
          child: RegistrationForm(),
        ),
      ),
    );
  }
}
