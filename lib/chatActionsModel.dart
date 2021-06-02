import 'package:flutter/material.dart';
import 'package:chatdemo/actionModel.dart';

class ChatActions extends StatelessWidget {

  final List<dynamic> actions;
  final String from;
  final Function(String) sendAction;

  ChatActions({Key? key, required this.actions, required this.from, required this.sendAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 5.0,
            runSpacing: 10.0,
            children: List<Widget>.generate(actions.length, (int index) {
              return ActionChip(
                  label: Text(actions[index].title),
                  backgroundColor: Colors.amber,
                  onPressed: () {
                    sendAction(actions[index].value);
                  }
              );
            }),
          ),
      );
    }
}
