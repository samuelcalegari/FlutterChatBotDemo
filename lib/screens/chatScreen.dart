import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatdemo/models/conversations/conversations.dart';
import 'package:chatdemo/screens/components/app_bar.dart';
import 'package:chatdemo/screens/components/bottom_bar_widget.dart';
import 'package:chatdemo/screens/components/chat_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/User.dart';
import '../models/messages/Message.dart' as BotMessage;
import '../utilities/api_manager.dart';
import '../utilities/constants.dart';

enum ChatState { NOTCONNECTED, CONNECTING, CONNECTED, EXPIRED }

class NewChatScreen extends StatefulWidget {
  NewChatScreen({Key? key, required this.user}) : super(key: widgetKey);
  final User user;
  static GlobalKey<_NewChatScreenState> widgetKey = GlobalKey();

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  GlobalKey<BottomBarWidgetState> bottomBarKey = GlobalKey();
  late Conversation conversationInfo;

  StreamController<dynamic> streamController = StreamController<dynamic>();

  var chatStatus = ChatState.NOTCONNECTED;
  late ChatListWidget chatListWidget;
  var isAutoLog = true;
  @override
  void initState() {
    super.initState();
    chatListWidget = ChatListWidget(username: widget.user.userName);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      connectToConversation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          getBody().paddingBottom(kToolbarHeight),
          BottomBarWidget(
            key: bottomBarKey,
            sendMessageCallback: (msg) {
              sendMessageToBot(msg);
            },
          )
        ],
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(),
      body: getBody(),
      bottomNavigationBar: BottomBarWidget(
        sendMessageCallback: (msg) {
          sendMessageToBot(msg);
        },
      ),
    );
  }

  User getUser() {
    return widget.user;
  }

  Future connectToConversation() async {
    setState(() {
      this.chatStatus = ChatState.CONNECTING;
    });
    var conversation = await ApiManager.getConversationInfo();
    if (conversation != null) {
      this.conversationInfo = conversation;
      setupConversationStream(this.conversationInfo);
    }
  }

  Widget getBody() {
    switch (chatStatus) {
      case ChatState.NOTCONNECTED:
        return Center(child: CircularProgressIndicator());
      case ChatState.CONNECTING:
        return Center(child: CircularProgressIndicator());
      case ChatState.CONNECTED:
        return chatListWidget;
      case ChatState.EXPIRED:
        print("La connexion à expirer");
        return Center(child: CircularProgressIndicator());
    }
  }

  void setupConversationStream(Conversation conversation) async {
    Stream stream = streamController.stream;
    if (botsManager.moodleToken != null) {
      var test = await ApiManager.setConversationData(botsManager.moodleToken!,
          conversation.conversationId, widget.user.userId.toString());
      print(test);
    }
    var channel = IOWebSocketChannel.connect(conversation.streamUrl);
    streamController.addStream(channel.stream);
    stream.listen((value) {
      if (value is String && value.isNotEmpty) {
        setState(() {
          try {
            if (isAutoLog) {
              var message = BotMessage.Message.fromJson(json.decode(value));
              switch (message.getMessagePosition()) {
                case 0:
                  return;
                case 1:
                  return;
                case 2:
                  sendMessageToBot(widget.user.userName);
                  break;
                case 3:
                  return;
                default:
                  if (bottomBarKey.currentState?.isEnabled == false) {
                    bottomBarKey.currentState?.enableInput();
                  }

                  ChatListWidget.widgetKey.currentState?.addMessage(
                      BotMessage.Message.fromJson(json.decode(value)));

                  //messages.add(Message.fromJson(json.decode(value)));
                  return;
              }

              return;
            }

            ChatListWidget.widgetKey.currentState
                ?.addMessage(BotMessage.Message.fromJson(json.decode(value)));

            //messages.add(Message.fromJson(json.decode(value)));
          } catch (e) {
            //print("impossible de parser le message");
          }
        });
      }
    });

    setState(() {
      chatStatus = ChatState.CONNECTED;
      _startConversation();
    });
  }

  _startConversation() {
    try {
      sendMessageToBot("Bonjour");
    } catch (e) {
      print('erreur envoi message');
      print(e.toString());
    }
  }

  sendMessageToBot(msg) async {
    if (conversationInfo.token != null) {
      final fmsg = jsonEncode({
        "locale": "fr-FR",
        "type": "message",
        "from": {"id": "user"},
        "text": msg
      });

      final response = await http.post(
        Uri.parse(APIConstants.DIRECTLINE_BASE_URL +
            APIOperations.getConversation +
            conversationInfo.conversationId +
            '/activities'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + conversationInfo.token!,
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: fmsg,
      );

      final responseJson = jsonDecode(response.body);
      print(Uri.parse(APIConstants.DIRECTLINE_BASE_URL +
          APIOperations.getConversation +
          conversationInfo.conversationId +
          '/activities'));
    }
  }
}
