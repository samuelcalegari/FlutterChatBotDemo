import 'package:flutter/material.dart';

class ChatActions extends StatelessWidget {

  final Object content;
  final String from;
  final Function(String) sendAction;

  ChatActions({Key? key, required this.content, required this.from, required this.sendAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              ActionChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: const Text('NM'),
                  ),
                  label: const Text('Nathalie Matheu'),
                  onPressed: () {
                    sendAction('Nathalie Matheu');
                  }
              ),
              ActionChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: const Text('SC'),
                  ),
                  label: const Text('Samuel Calegari'),
                  onPressed: () {
                    sendAction('Samuel Calegari');
                  }
              )
            ],
          ),
      );
    }
}
