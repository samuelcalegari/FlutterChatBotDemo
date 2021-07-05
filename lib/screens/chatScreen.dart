import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/ActionModel.dart';
import 'package:chatdemo/models/CardModel.dart';
import 'package:chatdemo/models/ChatCardsModel.dart';
import 'package:chatdemo/models/ChatMessageModel.dart';
import 'package:chatdemo/models/ChatActionsModel.dart';
import 'package:chatdemo/models/User.dart';

String _token = '';
String _streamUrl = '';
String _conversationId = '';

Future<String> _getToken() async {
  final response = await http.post(
    Uri.parse(
        APIConstants.DIRECTLINE_BASE_URL+APIOperations.getTokenFromDirectLine),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + APITokens.DIRECTLINE_TOKEN,
    },
  );
  final responseJson = jsonDecode(response.body);
  _token = responseJson['token'];

  return _token;
}

Future<String> _getStreamUrl() async {
  await _getToken();
  final response = await http.post(
    Uri.parse(
        APIConstants.DIRECTLINE_BASE_URL+APIOperations.getConversation),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + _token,
    },
  );

  final responseJson = jsonDecode(response.body);

  _streamUrl = responseJson['streamUrl'];

  _conversationId = responseJson['conversationId'];

  return _streamUrl;
}

_sendMessage(msg) async {
  final fmsg = jsonEncode({
    "locale": "fr-FR",
    "type": "message",
    "from": {"id": "user"},
    "text": msg
  });

  final response = await http.post(
    Uri.parse(
        APIConstants.DIRECTLINE_BASE_URL+APIOperations.getConversation +
            _conversationId +
            '/activities'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + _token,
      HttpHeaders.contentTypeHeader: "application/json"
    },
    body: fmsg,
  );

  final responseJson = jsonDecode(response.body);

  print(responseJson);
}

class ChatScreen  extends StatefulWidget {

  final User user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(context) {
    return FutureBuilder<String>(
        future: _getStreamUrl(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: Config.APP_NAME,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: MyHomePage(channel: IOWebSocketChannel.connect(_streamUrl)),
            );
          } else {
            return MaterialApp(
              title: Config.APP_NAME,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  WebSocketChannel channel;
  int watermark = 0;

  MyHomePage({Key? key, required this.channel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _msgText = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List messages = [];

  _startConversation() {
    try {
      _sendMessage("Bonjour");
    } catch (e) {
      print('erreur envoi message');
      print(e.toString());
    }
  }

  _send() {
    setState(() {
      if (_msgText.text.isNotEmpty) {
        // Add Message
        try {
          _sendMessage(_msgText.text);
          print('message envoyé');
        } catch (e) {
          print('erreur envoi message');
          print(e.toString());
        }

        // Remove Focus on Text Input
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        // Clear Text Input
        _msgText.text = '';
      }
    });
  }

  _scrollBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      APIConstants.BOTAVATAR),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Config.APP_NAME,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: ElevatedButton(
                        onPressed: _startConversation,
                        child: const Text('Start')));
              }

              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(child: const Text('Une erreur est survenue ...'));
              } else if (snapshot.hasData) {
                try {
                  int? w;
                  dynamic obj = jsonDecode(snapshot.data);
                  String from = obj['activities'][0]['from']['id'];
                  final suggestedActions =
                      obj['activities'][0]['suggestedActions'] ?? null;
                  final attachments =
                      obj['activities'][0]['attachments'] ?? null;

                  print('\n#########################\n');
                  //print(obj);
                  //print(obj['watermark']);
                  //print(suggestedActions);
                  //print(attachments);

                  if (attachments != null) {
                    List<dynamic> c = attachments.map((e) {

                      if (e['contentType'] ==
                          'application/vnd.microsoft.card.hero') {
                        return CardInfos(
                            type: e['contentType'],
                            title: e['content']['title'],
                            text: e['content']['text'],
                            urlImg: e['content']['images'][0]['url'],
                            actions: e['content']['buttons']
                                .map((e) => ActionInfos(
                                type: e['type'],
                                title: e['title'],
                                value: e['value']))
                                .toList());
                      } else {

                        final _se1 = e['content']['body'][4]['columns'][0]['items'][0]['text'] + '\n' + e['content']['body'][4]['columns'][0]['items'][1]['text'];
                        final _se2 = e['content']['body'][4]['columns'][1]['items'][0]['text'] + '\n' +  e['content']['body'][4]['columns'][1]['items'][1]['text'];

                        final _url = e['content']['body'][5]['actions'][0]['url'];

                        var re = RegExp(r'(?<=mod\/)(.*)(?=\/view)');
                        var match = re.firstMatch(_url);
                        var _template = (match != null)  ? match.group(0) : "default";

                        return CardInfos2(
                            type: e['contentType'],
                            template : _template.toString(),
                            title: e['content']['body'][1]['text'],
                            text: e['content']['body'][2]['text'],
                            subElement1: _se1,
                            subElement2: _se2,
                            actions: [ ActionInfos(
                                type: e['content']['body'][5]['actions'][0]['type'],
                                title: e['content']['body'][5]['actions'][0]['title'],
                                value: _url
                            )
                            ]);
                      }
                    }).toList();

                    messages.add(ChatCards(
                        cardsinfos: c, from: from, sendAction: _sendMessage));
                  }

                  if (from != 'user') {
                    w = int.tryParse(obj['watermark']);
                  }

                  if ((from == "user") || (w != widget.watermark)) {
                    messages.add(ChatMessage(
                        content: obj['activities'][0]['text'], from: from));

                    if (from != 'user' && w != null) widget.watermark = w;
                  }

                  if (suggestedActions != null) {
                    List<dynamic> a = suggestedActions['actions']
                        .map((e) => ActionInfos(
                        type: e['type'],
                        title: e['title'],
                        value: e['value']))
                        .toList();

                    messages.add(ChatActions(
                        actions: a, from: from, sendAction: _sendMessage));
                  }

                  // AutoScroll when data incoming
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scrollBottom();
                  });
                } catch (e) {}

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  shrinkWrap: false,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.only(top: 10, bottom: 100),
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                );
              } else {
                return Center(child: const Text('...'));
              }
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _scrollBottom();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
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
                      controller: _msgText,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: _send,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

