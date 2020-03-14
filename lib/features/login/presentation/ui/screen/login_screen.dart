import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_bloc.dart';
import 'package:hotfoot/features/login/presentation/ui/widgets/login_form.dart';
import 'package:hotfoot/injection_container.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<LoginBloc>(
        create: (context) => sl<LoginBloc>(),
        child: LoginForm(),
      ),
    );
  }
}
