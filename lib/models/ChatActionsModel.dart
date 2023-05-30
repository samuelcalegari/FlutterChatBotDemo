import 'package:chatdemo/models/messages/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ChatMessageModel.dart';

class ChatActions extends StatelessWidget {
  final List<dynamic> actions;
  final Message message;
  final Function(String) sendAction;
  final bool disableActions;

  ChatActions(
      {Key? key,
      required this.actions,
      required this.message,
      required this.sendAction,
      this.disableActions = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (message.text != null)
          ChatMessage(
            message: message,
          ),
        Padding(
          padding: EdgeInsets.only(left: 14, right: 14, bottom: 8),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 5.0,
            children: List<Widget>.generate(actions.length, (int index) {
              return ActionChip(
                  label: Text(
                    actions[index].title,
                    style: context.theme.textTheme.labelLarge?.copyWith(
                        color: disableActions
                            ? CupertinoColors.inactiveGray
                            : Colors.black),
                  ),
                  pressElevation: disableActions ? 0 : 2,
                  backgroundColor: disableActions
                      ? CupertinoColors.lightBackgroundGray
                      : Colors.amber,
                  onPressed: () {
                    if (!disableActions) {
                      sendAction(actions[index].value);
                    }
                  });
            }),
          ),
        )
      ],
    ));
  }
}
