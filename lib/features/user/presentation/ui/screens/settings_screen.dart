import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_bloc.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_funds_widget.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_photo_widget.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_type_widget.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/injection_container.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Authenticated authState =
        BlocProvider.of<NavigationAuthBloc>(context).state;
    final user = authState.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome()),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: BlocProvider<UserFundsBloc>(
          create: (context) => sl<UserFundsBloc>(),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 70.0),
                UserPhotoWidget(
                  userId: null,
                  borderWidth: 15,
                  radius: 120,
                  editable: true,
                  onTap: null,
                ),
                SizedBox(height: 24.0),
                Center(
                    child: Text(
                  '$user',
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 24),
                UserTypeWidget(),
                UserFundsWidget(),
                SizedBox(height: 24.0),
                Center(
                  child: signOutButton(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget signOutButton(context) {
  return ButtonTheme(
    minWidth: 150,
    child: RaisedButton(
      elevation: 3,
      padding: EdgeInsets.fromLTRB(0.0, 12.5, 0.0, 12.5),
      color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: () {
        // Log out of application
        BlocProvider.of<NavigationAuthBloc>(context).add(
          LoggedOut(),
        );
      },
      child: Text(
        'Signout',
        textAlign: TextAlign.center,
        style: style.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
  );
}
