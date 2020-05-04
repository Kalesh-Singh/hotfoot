import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_photo_widget.dart';

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    final runModel =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel;
    final userType =
        BlocProvider.of<UserTypeBloc>(context).state is RunnerUserType
            ? UserType.RUNNER
            : UserType.CUSTOMER;
    final otherUserId =
        (userType == UserType.RUNNER) ? runModel.customerId : runModel.runnerId;
    final Authenticated authState =
        BlocProvider.of<NavigationAuthBloc>(context).state;
    final currentUserEmail = authState.displayName;
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: currentUserEmail == messageSnapshot.value['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(otherUserId),
        ),
      ),
    );
  }

  String _capitalize(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  String _parseBisonEmail(String email) {
    String firstNameDotLastname = email.substring(0, email.indexOf('@'));
    final nameArray = firstNameDotLastname.split(".");
    return _capitalize(nameArray[0]) + " " + _capitalize(nameArray[1]);
  }

  List<Widget> getSentMessageLayout() {
    String senderName = _parseBisonEmail(messageSnapshot.value['senderName']);
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(senderName,
                style: style.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                messageSnapshot.value['text'],
                style: style.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: UserPhotoWidget(
              radius: 20,
              editable: false,
              borderWidth: 2,
              userId: null,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout(String otherUserId) {
    String senderName = _parseBisonEmail(messageSnapshot.value['senderName']);
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: UserPhotoWidget(
              radius: 20,
              editable: false,
              borderWidth: 2,
              userId: otherUserId,
            ),
          ),
        ],
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(senderName,
                style: style.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(messageSnapshot.value['text'],
                  style: style.copyWith(fontSize: 12)),
            ),
          ],
        ),
      ),
    ];
  }
}
