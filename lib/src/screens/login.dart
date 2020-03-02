import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/src/utils/user_repository.dart';
import 'package:hotfoot/src/blocs/login_bloc/login.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: SafeArea(
//           child: ListView(
//             padding: EdgeInsets.symmetric(horizontal: 24.0),
//             children: <Widget>[
//               SizedBox(height: 80.0),
//               Column(
//                 children: <Widget>[
//                   Image.asset('assets/asteroid.png'),
//                   SizedBox(height: 20.0),
//                   Text('Hotfoot'),
//                 ],
//               ),
//               SizedBox(height: 45.0),
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   filled: true,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               // Password
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   filled: true,
//                 ),
//                 obscureText: true,
//               ),
//               SizedBox(height: 45.0),
//               Center(
//                 child: loginButton(context),
//               ),
//             ],
//           ),
//         )
//     );
//   }
// }

// Widget loginButton(context) {
//   return RaisedButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/app_state');
//     },
//     child: Text('Login'),
//     color: Colors.amber,
//     padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
//   );
// }
