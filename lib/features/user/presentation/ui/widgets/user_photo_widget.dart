import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_state.dart';
import 'package:hotfoot/injection_container.dart';

class UserPhotoWidget extends StatelessWidget {
  final String userId;
  final double radius;
  final double borderWidth;
  final String initialsText;
  final double initialsTextSize;
  final void Function() onTap;

  UserPhotoWidget({
    @required this.userId,
    @required this.radius,
    @required this.borderWidth,
    @required this.initialsText,
    @required this.initialsTextSize,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserPhotoBloc>()..add(UserPhotoRequested(userId: null)),
      child: Container(
        child: BlocBuilder<UserPhotoBloc, UserPhotoState>(
            builder: (BuildContext context, UserPhotoState state) {
          if (state is UserPhotoLoadFailure ||
              state is UserPhotoUpdateFailure ||
              state is UserPhotoUninitialized) {
            return CircularProfileAvatar(
              '',
              //sets image path, it should be a URL string. default value is
              // empty string, if path is empty it will display only initials
              radius: radius,
              // sets radius, default 50.0
              backgroundColor: Colors.transparent,
              // sets background color, default Colors.white
              borderWidth: borderWidth,
              // sets border, default 0.0
              initialsText: Text(
                initialsText,
                style:
                    TextStyle(fontSize: initialsTextSize, color: Colors.white),
              ),
              // sets initials text, set your own style, default Text('')
              borderColor: Colors.deepOrange.shade400,
              // sets border color, default Colors.white
              elevation: 5.0,
              // sets elevation (shadow of the profile picture),
              // default value is 0.0
              foregroundColor: Colors.deepOrange.shade400,
              //sets foreground colour, it works if
              // showInitialTextAbovePicture = true , default Colors.transparent
              cacheImage: true,
              // allow widget to cache image against provided url
              onTap: onTap,
              // sets on tap
              showInitialTextAbovePicture: true,
              // setting it true will show initials text above
              // profile picture, default false
            );
          } else if (state is UserPhotoLoadSuccess) {
            final photoBytes = state.userPhoto.readAsBytesSync();
            return CircularProfileAvatar(
              '',
              child: Image.memory(photoBytes),
              radius: radius,
              borderWidth: borderWidth,
              borderColor: Colors.deepOrange,
              elevation: 5.0,
              onTap: onTap,
            );
          } else if (state is UserPhotoUpdateSuccess) {
            final photoBytes = state.userPhoto.readAsBytesSync();
            return CircularProfileAvatar(
              '',
              child: Image.memory(photoBytes),
              radius: radius,
              borderWidth: borderWidth,
              borderColor: Colors.deepOrange,
              elevation: 5.0,
              onTap: onTap,
            );
          }
          return Container();
        }),
      ),
    );
  }
}
