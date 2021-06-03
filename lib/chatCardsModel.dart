import 'package:flutter/material.dart';

class ChatCards extends StatelessWidget {

  final List<dynamic> cardsinfos;
  final String from;
  final Function(String) sendAction;

  ChatCards({Key? key, required this.cardsinfos, required this.from, required this.sendAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Container();
    }
}
