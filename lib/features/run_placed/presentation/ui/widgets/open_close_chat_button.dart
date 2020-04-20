import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/chat_section.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';

class OpenCloseChatButton extends StatelessWidget {
  final RunModel runModel;
  final String buttonText;

  OpenCloseChatButton({
    @required this.runModel,
    @required this.buttonText,
  }) : assert(runModel != null),
       assert(buttonText != null);

  Column _chatSection() {
    return 
    Column(children: <Widget>[
      Expanded(
          child: ChatSection(runModel: runModel,),
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
      label: Text(buttonText, style: TextStyle(color: Colors.white)),
      color: Colors.blueAccent,
      ),
    );
  }
}