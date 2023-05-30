import 'package:chatdemo/models/messages/Message.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  ChatMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.title == null &&
        message.text == null &&
        message.attachments.attachments.isEmpty) {
      return Container();
    }
    return Padding(
        padding: EdgeInsets.only(top: 12, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: !message.isFromUser()
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.text != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (!message.isFromUser()
                      ? Colors.grey.shade200
                      : Colors.blue[200]),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  message.text!,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            if (message.getFormatedDateToString() != null)
              Text(
                message.getFormatedTimeToString()!,
                style: context.theme.textTheme.caption,
              ).paddingSymmetric(horizontal: 8)
          ],
        ));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 2),
          child: Align(
            alignment: (message.from != "user"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (message.from != "user"
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message.text!,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        if (message.getFormatedDateToString() != null)
          Text(message.getFormatedDateToString()!)
      ],
    );
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
      child: Align(
        alignment:
            (message.from != "user" ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (message.from != "user"
                ? Colors.grey.shade200
                : Colors.blue[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message.text!,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
