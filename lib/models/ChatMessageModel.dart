import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String content;
  final String from;


  ChatMessage({Key? key, required this.content, required this.from}) : super(key: key);

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
            child: Text(content, style: TextStyle(fontSize: 12),),
          ),
        ),
      );
  }
}
