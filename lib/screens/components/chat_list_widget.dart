import 'package:chatdemo/models/messages/InfoMessage.dart';
import 'package:chatdemo/models/messages/Message.dart' as BotMessage;
import 'package:chatdemo/utilities/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ActionModel.dart';
import '../../models/ChatActionsModel.dart';
import '../../models/ChatCardsModel.dart';
import '../../models/ChatMessageModel.dart';
import '../chatScreen.dart';

class ChatListWidget extends StatefulWidget {
  static GlobalKey<ChatListWidgetState> widgetKey = GlobalKey();
  final String? username;
  ChatListWidget({Key? key, this.username}) : super(key: widgetKey);
  final int watermark = 0;

  @override
  State<ChatListWidget> createState() => ChatListWidgetState();
}

class ChatListWidgetState extends State<ChatListWidget> {
  ScrollController _scrollController = ScrollController();
  late Box messageBox;
  var isLoading = true;
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.username != null) {
        messageBox = await Hive.openBox(widget.username!);
        if (messageBox.isNotEmpty) {
          messageBox.values.forEach((element) {
            if (element is BotMessage.Message) {
              element.isOldMessage = true;
            }
            messages.add(element);
          });
          messages.add(InfoMessage("Anciens messages"));
        }
      } else {
        messageBox = await Hive.openBox('messageBox');
      }
    });
  }

  void cleanHistory() {
    messageBox.clear();
    var lastMessage = messages.last;
    messages.clear();
    messages.add(lastMessage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index] is BotMessage.Message) {
          BotMessage.Message message = messages[index];
          int? w;

          if (message.attachments.attachments.length > 0) {
            print("attachments data : " + message.attachments.toString());
            message.attachments.attachments.map((e) => print(
                "attachments data : " + e.attachmentContentType.toString()));
            return MessageAttachmentCardWidget(
              message: message,
              sendAction: (value) {
                if (Uri.tryParse(value)?.hasAbsolutePath == true) {
                  launch(value);
                } else {
                  sendMessage(value);
                }
              },
            );

            /*  List<dynamic> attachments = message.attachments.attachments.map(
              (e) {
                if (e.attachmentContentType == AttachmentContentType.HeroCard) {
                  return CardInfos(
                      type: e.attachmentContentType.toString(),
                      title: e.title,
                      text: e.text,
                      urlImg: e.images.imgs.first.url,
                      actions: e.actionsList.actions
                          .map((action) => ActionInfos(
                              type: action.type,
                              title: action.title,
                              value: action.value))
                          .toList());
                } else {
                  try {
                    final _se1 = e.body[4]['columns'][0]['items'][0]['text'] +
                        '\n' +
                        e.body[4]['columns'][0]['items'][1]['text'];
                    final _se2 = e.body[4]['columns'][1]['items'][0]['text'] +
                        '\n' +
                        e.body[4]['columns'][1]['items'][1]['text'];

                    final _url = e.body[5]['actions'][0]['url'];

                    var re = RegExp(r'(?<=mod\/)(.*)(?=\/view)');
                    var match = re.firstMatch(_url);
                    var _template =
                        (match != null) ? match.group(0) : "default";

                    return CardInfos2(
                        type: e.attachmentContentType.toString(),
                        template: _template.toString(),
                        title: e.body[1]['text'],
                        text: e.body[2]['text'],
                        subElement1: _se1,
                        subElement2: _se2,
                        actions: [
                          ActionInfos(
                              type: e.body[5]['actions'][0]['type'],
                              title: e.body[5]['actions'][0]['title'],
                              value: _url)
                        ]);
                  } catch (exception) {
                    return CardInfos2(
                        type: e.attachmentContentType.toString(),
                        template: null,
                        title: e.title,
                        urlImg: e.images.imgs.first.url,
                        text: e.text,
                        subElement1: null,
                        subElement2: null,
                        actions: e.actionsList.actions);
                  }
                }
              },
            ).toList();*/
            // List<Attachment> c =
            //     message.attachments.attachments.map((attachment) {
            //   if (attachment.attachmentContentType ==
            //       AttachmentContentType.HeroCard) {
            //     return CardInfos(
            //         type: attachment.attachmentContentType.toString(),
            //         title: attachment.title,
            //         text: attachment.text,
            //         urlImg: attachment.images.first,
            //         actions: attachment.actions
            //             .map((action) => ActionInfos(
            //                 type: action.type,
            //                 title: action.title,
            //                 value: action.value))
            //             .toList());
            //   } else {
            //     final _se1 = attachment.body[4]['columns'][0]['items'][0]
            //             ['text'] +
            //         '\n' +
            //         attachment.body[4]['columns'][0]['items'][1]['text'];
            //     final _se2 = attachment.body[4]['columns'][1]['items'][0]
            //             ['text'] +
            //         '\n' +
            //         attachment.body[4]['columns'][1]['items'][1]['text'];

            //     final _url = attachment.body[5]['actions'][0]['url'];

            //     var re = RegExp(r'(?<=mod\/)(.*)(?=\/view)');
            //     var match = re.firstMatch(_url);
            //     var _template = (match != null) ? match.group(0) : "default";

            //     return CardInfos2(
            //         type: attachment.attachmentContentType.toString(),
            //         template: _template.toString(),
            //         title: attachment.body[1]['text'],
            //         text: attachment.body[2]['text'],
            //         subElement1: _se1,
            //         subElement2: _se2,
            //         actions: [
            //           ActionInfos(
            //               type: attachment.body[5]['actions'][0]['type'],
            //               title: attachment.body[5]['actions'][0]['title'],
            //               value: _url)
            //         ]);
            //   }
            // }).toList();
            // return ChatCards(
            //    cardsinfos: attachments,
            //   from: message.from,
            //   sendAction: sendMessage);
          } else if (message.from != 'user') {
            w = int.tryParse(message.watermark);
          } else if ((message.from == "user") || (w != widget.watermark)) {
            return ChatMessage(message: message);

            // if (from != 'user' && w != null) widget.watermark = w;
          }

          if (message.suggestedActions.length > 0) {
            List<dynamic> a = message.suggestedActions
                .map((e) =>
                    ActionInfos(type: e.type, title: e.title, value: e.value))
                .toList();

            return ChatActions(
                actions: a,
                disableActions: message.isOldMessage,
                message: message,
                sendAction: sendMessage);
          }
          return ChatMessage(
            message: message,
          );
        } else if (messages[index] is InfoMessage) {
          return Column(
            children: [
              Icon(Icons.arrow_upward),
              Text(
                "Anciens messages",
                style: context.theme.textTheme.labelMedium,
              )
            ],
          );
        }
        return Text("pas message");
      },
    );
  }

// Send message to Direct Line
  sendMessage(msg) async {
    print("d");
    ChatScreen.widgetKey.currentState?.sendMessageToBot(msg);
    scrollBottom();
    // if (conversation != null && conversation!.token != null) {
    //   final fmsg = jsonEncode({
    //     "locale": "fr-FR",
    //     "type": "message",
    //     "from": {"id": "user"},
    //     "text": msg
    //   });

    //   final response = await http.post(
    //     Uri.parse(APIConstants.DIRECTLINE_BASE_URL +
    //         APIOperations.getConversation +
    //         conversation!.conversationId +
    //         '/activities'),
    //     headers: {
    //       HttpHeaders.authorizationHeader: "Bearer " + conversation!.token!,
    //       HttpHeaders.contentTypeHeader: "application/json"
    //     },
    //     body: fmsg,
    //   );

    //   final responseJson = jsonDecode(response.body);

    //   print(responseJson);
    // }
  }

  addMessage(BotMessage.Message message) async {
    print(message.text);
    setState(() {
      messages.add(message);
      messageBox.add(message);
    });

    Future.delayed(200.milliseconds, () {
      scrollBottom();
    });
  }

  startConversation() {
    try {
      sendMessage("Bonjour");
    } catch (e) {
      print('erreur envoi message');
      print(e.toString());
    }
  }

  scrollBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    }
  }
}
