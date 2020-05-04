import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/chat_message_list_item.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/core/util/util.dart';

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

class ChatSection extends StatelessWidget {
  final RunModel runModel;

  ChatSection({
    @required this.runModel,
  }) : assert(runModel != null);

  String makeReferenceId() {
    // Will return messages for now to not break app
    if (runModel.customerId == null || runModel.runnerId == null) {
      return 'messages';
    }
    else {
      // Can also append date or whatever discerning factors to create unique chatrooms
      // ! Regex will remove all special characters, appends the date as a series of numbers at the end to ENSURE unique chat room
      String referenceId = runModel.customerId+runModel.runnerId + runModel.timePlaced.toString().
                                                                  replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
      print(referenceId);
      return referenceId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String referenceId = makeReferenceId();
    final DatabaseReference reference = FirebaseDatabase.instance.reference().child(referenceId);
    return  Container(
      child:  ChatWindow(
                        firebaseAuth: sl(), 
                        referenceId: referenceId, 
                        reference: reference
                        ),
    );
  }
}

class ChatWindow extends StatelessWidget {
  final FirebaseAuth firebaseAuth;
  final TextEditingController _textController = TextEditingController();
  final String referenceId;
  final reference;

  ChatWindow({
    @required this.firebaseAuth,
    @required this.referenceId,
    @required this.reference
  }) : assert(firebaseAuth != null),
       assert(referenceId != null),
       assert(reference != null);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text("Chat"),
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
          child: _buildComposer(context),
          decoration:  BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }


  Widget _buildComposer(BuildContext context) {
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
                    },
                    onSubmitted: _submitMsg,
                    style: style.copyWith(fontSize: 12),
                    decoration:
                       InputDecoration.collapsed(hintText: "Enter some text to send a message"),
                  ),
              ),
               Container(
                margin:  EdgeInsets.symmetric(horizontal: 3.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                  ?  CupertinoButton(
                    child:  Text("Submit", style: style.copyWith(fontSize: 12),),
                    onPressed: () => _submitMsg(_textController.text),
                )
                    :  IconButton(
                    icon:  Icon(Icons.message),
                    onPressed: () => _submitMsg(_textController.text),
                ),
              ),
            ],
          ),
        )
    );
  }

  void _submitMsg(String txt) async {
    _textController.clear();
    final FirebaseUser __firebaseUser = await firebaseAuth.currentUser();
    _sendMessage(messageText: txt, firebaseUser: __firebaseUser);
  }

  void _sendMessage({String messageText, FirebaseUser firebaseUser}) {
    String formattedMsg = messageText.trim();
    if (formattedMsg.length != 0) {
      reference.push().set({
      'text': formattedMsg,
      'email': firebaseUser.email,
      'senderName': Util.parseBisonEmail(firebaseUser.email),
      });
    }
  }
}