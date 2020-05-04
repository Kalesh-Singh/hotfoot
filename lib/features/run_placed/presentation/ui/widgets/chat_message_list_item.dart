import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/core/style/style.dart';

var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    return  SizeTransition(
      sizeFactor:
       CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child:  Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child:  Row(
          children: currentUserEmail == messageSnapshot.value['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
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
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
             Text(senderName,
                style: style.copyWith(
                  color: Colors.black, 
                  fontSize: 14, 
                  fontWeight: FontWeight.bold)
                ),
             Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(messageSnapshot.value['text'], style: style.copyWith(fontSize: 12),),
            ),
          ],
        ),
      ),
       Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
           Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: FaIcon(FontAwesomeIcons.user, color: Colors.black),
              ),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    String senderName = _parseBisonEmail(messageSnapshot.value['senderName']);
    return <Widget>[
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Container(
              margin: const EdgeInsets.only(right: 8.0),
//              child: FaIcon(FontAwesomeIcons.user, color: Colors.black),

              ),
        ],
      ),
       Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Text(senderName,
                style:  style.copyWith(
                  color: Colors.black, 
                  fontSize: 14, fontWeight: 
                  FontWeight.bold)
                ),
             Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(messageSnapshot.value['text'], style: style.copyWith(fontSize: 12)),
            ),
          ],
        ),
      ),
    ];
  }
}
