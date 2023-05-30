import 'package:chatdemo/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'chat_list_widget.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({Key? key, required this.sendMessageCallback})
      : super(key: key);
  final Function(String) sendMessageCallback;
  @override
  State<BottomBarWidget> createState() => BottomBarWidgetState();
}

class BottomBarWidgetState extends State<BottomBarWidget> {
  final TextEditingController msgTextController = TextEditingController();
  FocusNode msgTextNode = FocusNode();
  var isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: kToolbarHeight,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ChatListWidget.widgetKey.currentState?.scrollBottom();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: isEnabled ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  enabled: isEnabled,
                  focusNode: msgTextNode,
                  controller: msgTextController,
                  decoration: InputDecoration(
                      hintText:
                          isEnabled ? "Ecrire un message..." : "Chargement...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: isEnabled
                    ? () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.focusedChild?.unfocus();
                        }
                        widget.sendMessageCallback(msgTextController.text);
                        msgTextController.text = "";
                        // ChatListWidget.widgetKey.currentState
                        //     ?.send(msgTextController.text);
                      }
                    : null,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: isEnabled ? Colors.blue : Colors.grey,
                elevation: 0,
              ),
            ],
          ),
        )));
  }

  void enableInput() {
    setState(() {
      isEnabled = true;
    });
  }
}
