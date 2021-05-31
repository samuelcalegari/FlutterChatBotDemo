import 'package:flutter/material.dart';

class ChatActions extends StatelessWidget {

  final Object content;
  final String from;
  final Function(String)? onClick;

  ChatActions({Key? key, required this.content, required this.from, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
        child: Align(
          alignment: (from != "user" ? Alignment.topLeft : Alignment
              .topRight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (from != "user" ? Colors.grey.shade200 : Colors
                  .blue[200]),
            ),
            padding: EdgeInsets.all(16),
            child: Text(content.toString(), style: TextStyle(fontSize: 12),),
          ),
        ),
      );
    }
}
