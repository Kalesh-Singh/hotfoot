import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_event.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_state.dart';
import 'package:hotfoot/features/registration/presentation/ui/widgets/registration_button.dart';

class RegistrationForm extends StatefulWidget {
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegistrationBloc _registrationBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegistrationButtonEnabled(RegistrationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration in Progress...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess && state.isEmailVerified) {
          print(state);
          BlocProvider.of<NavigationAuthBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isSuccess && state.isEmailVerified == false) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Please verify your email address'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.blue,
              ),
            );
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.message),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/HotFoot.png', height: 250),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (_) {
                      _emailFocus.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return displayEmailErrorMessage(
                          _emailController.text.toString(), state);
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocus,
                    onFieldSubmitted: (_) {
                      if (isRegistrationButtonEnabled(state)) {
                        _onFormSubmitted();
                      }
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return displayPasswordErrorMessage(
                          _passwordController.text.toString(), state);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(12.0)),
                  RegistrationButton(
                    onPressed: isRegistrationButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to help with displaying an appropriate message
  String displayEmailErrorMessage(
      String _emailAddress, RegistrationState _emailAddressState) {
    if (_emailAddressState.isEmailValid) {
      return null;
    } else {
      return 'john.doe@bison.howard.edu';
    }
  }

  String displayPasswordErrorMessage(
      String _password, RegistrationState _passwordState) {
    if (_passwordState.isPasswordValid) {
      return null;
    } else {
      // Password needs to have at least 8 characters, one of which must be a number
      // I cannot think of an appropriate message to show here
      // So I will just put 'Password is invalid' for now
      if( !_password.contains(RegExp(r'[0-9]')) ) {
        return 'Password needs at least 1 digit';
      }
      if (_password.length < 8) {
        return 'Password must be 8 characters or more';
      }
      if( _password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>+/]'))) {
        return 'Password should not have special characters';
      }
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registrationBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registrationBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registrationBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
