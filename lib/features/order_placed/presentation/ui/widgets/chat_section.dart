
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/features/order_placed/presentation/ui/widgets/chat_message_list_item.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:firebase_database/firebase_database.dart';

// https://www.youtube.com/watch?v=WwhyaqNtNQY

final ThemeData iOSTheme =  ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme =  ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

const String defaultUserName = "John Doe";

class ChatSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  @override
  State createState() =>  ChatWindow(firebaseAuth: sl());
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final FirebaseAuth firebaseAuth;
  final TextEditingController _textController = TextEditingController();
  // TODO Here we can create a unique FirebaseDatabase instance object using
  // TODO runners email concatanated with customer email such as email1-email2
  final reference = FirebaseDatabase.instance.reference().child('messages');
  bool _isWriting = false;

  ChatWindow({
    @required this.firebaseAuth,
  }) : assert(firebaseAuth != null);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text("Chat with runner"),
        elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body:  Column(
        children: <Widget>[
         Flexible(
           child: FirebaseAnimatedList(
             query: reference,
             padding: const EdgeInsets.all(8.0),
             reverse: true,
             sort: (a, b) => b.key.compareTo(a.key),
             itemBuilder: (_, DataSnapshot messageSnapshot, Animation<double> animation, __) {
               return ChatMessageListItem(
                 messageSnapshot: messageSnapshot,
                 animation: animation,
                  );
                },
              ),
            ),
         Container(
          child: _buildComposer(),
          decoration:  BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }


  Widget _buildComposer() {
    return  IconTheme(
        data:  IconThemeData(color: Theme.of(context).accentColor),
        child:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child:  Row(
            children: <Widget>[
               Flexible(
                  child:  TextField(
                    controller: _textController,
                    onChanged: (String txt) {
                      setState(() {
                        _isWriting = txt.length > 0;
                      });
                    },
                    onSubmitted: _submitMsg,
                    decoration:
                       InputDecoration.collapsed(hintText: "Enter some text to send a message"),
                  ),
              ),
               Container(
                margin:  EdgeInsets.symmetric(horizontal: 3.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                  ?  CupertinoButton(
                    child:  Text("Submit"),
                    onPressed: _isWriting ? () => _submitMsg(_textController.text)
                        : null
                )
                    :  IconButton(
                    icon:  Icon(Icons.message),
                    onPressed: _isWriting
                      ? () => _submitMsg(_textController.text)
                        : null,
                ),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
          ?  BoxDecoration(
            border:
               Border(top:  BorderSide(color: Colors.brown))) :
              null
        ),
    );
  }

  void _submitMsg(String txt) async {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    // TODO should probably do some check here so that we determine user is logged in
    // TODO but I believe the app would log out here anyway can double check later
    final FirebaseUser __firebaseUser = await firebaseAuth.currentUser();
    _sendMessage(messageText: txt, firebaseUser: __firebaseUser);
  }

  void _sendMessage({String messageText, FirebaseUser firebaseUser}) {
    reference.push().set({
      'text': messageText,
      'email': firebaseUser.email,
      'senderName': firebaseUser.email,
    });
  }
}