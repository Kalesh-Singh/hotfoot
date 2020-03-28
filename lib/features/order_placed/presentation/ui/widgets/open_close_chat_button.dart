import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/order_placed/presentation/ui/widgets/chat_section.dart';

class OpenCloseChatButton extends StatelessWidget {

  Column _chatSection() {
    return 
    Column(children: <Widget>[
      Expanded(
          child: ChatSection(),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return ButtonTheme (
      minWidth: 140.0,
      height: 40.0, 
    child: RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: FaIcon(FontAwesomeIcons.comments, color: Colors.white),
      onPressed: () {
        // ! Mysdreivus => Something like BlocProvider.of<ChatBloc>(context).add(ChatButtonPressed())
        // ! When button is pressed we need to close or open chat popup or navigate with back button not sure yet
        print("Contact Runner Button Tapped");
        showModalBottomSheet(
          context: context, 
          builder: (context) {
            return Container (
              color: Color(0xFF737373),
              height: MediaQuery.of(context).copyWith().size.height * 0.75,
              child:  Container(
                child: _chatSection(),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
              ),
            );
          },
        );
      },
      label: Text('Contact Runner', style: TextStyle(color: Colors.white)),
      color: Colors.blueAccent,
      ),
    );
  }
}