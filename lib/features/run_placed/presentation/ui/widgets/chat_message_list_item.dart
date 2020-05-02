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

  List<Widget> getSentMessageLayout() {
    return <Widget>[
       Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
             Text(messageSnapshot.value['senderName'],
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
    return <Widget>[
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: FaIcon(FontAwesomeIcons.user, color: Colors.black),
              ),
        ],
      ),
       Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Text(messageSnapshot.value['senderName'],
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
