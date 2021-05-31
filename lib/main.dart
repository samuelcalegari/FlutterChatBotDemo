import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatdemo/chatMessageModel.dart';


String _secret = 'ur2eVWbMew8.5nEjH6LT8mVIqUXmis9ixQ8kwFNheqIr8pclXlNrThQ';
String _token = '';
String _streamUrl = '';
String _conversationId  = '';

_getToken() async {

  final response = await http.post(
    Uri.parse('https://directline.botframework.com/v3/directline/tokens/generate'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + _secret,
    },
  );
  final responseJson = jsonDecode(response.body);
  _token = responseJson['token'];
}

_getStreamUrl() async {

  await _getToken();
  final response = await http.post(
    Uri.parse('https://directline.botframework.com/v3/directline/conversations/'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + _token ,
    },
  );

  final responseJson = jsonDecode(response.body);

  _streamUrl = responseJson['streamUrl'];

  _conversationId = responseJson['conversationId'];
}

_sendMessage(msg) async {

  final response = await http.post(
    Uri.parse('https://directline.botframework.com/v3/directline/conversations/' + _conversationId + '/activities'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + _token ,
      HttpHeaders.contentTypeHeader: "application/json"
    },
    body: msg,
  );

  final responseJson = jsonDecode(response.body);

  print(responseJson);
}

void main() {
  _getStreamUrl().whenComplete((){
    print("ok");
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miro Bot Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(channel: IOWebSocketChannel.connect(_streamUrl)),
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

  List<ChatMessage> messages = [];

  _startConversation() {

    try {

      final msg = jsonEncode({
        "locale": "fr-FR",
        "type": "message",
        "from": {
          "id": "user"
        },
        "text": "Bonjour"
      });

      _sendMessage(msg);


    } catch (e) {
      print ('erreur envoi message');
      print(e.toString());
    }

  }


  _send() {

    setState(() {

      if (_msgText.text.isNotEmpty) {

        // Add Message
        try {

          final msg = jsonEncode({
            "locale": "fr-FR",
            "type": "message",
            "from": {
              "id": "user"
            },
            "text": _msgText.text
          });

          _sendMessage(msg);
          print ('message envoyé');

        } catch (e) {
          print ('erreur envoi message');
          print(e.toString());
        }


        // Remove Focus on Text Input
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        // Scroll to Bottom
        /*
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn
        );*/


        // Clear Text Input
        _msgText.text = '';
      }
    });
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
                SizedBox(width: 10,),
                CircleAvatar(
                  backgroundImage: NetworkImage("https://forco.univ-perp.fr/theme/forco/bot/bot.png"),
                  maxRadius: 20,
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Miro Bot",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                Icon(Icons.settings,color: Colors.black54,),
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

              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: ElevatedButton(
                  onPressed: _startConversation,
                  child: const Text('Start'))
                );
              }

              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(child: const Text('Une erreur est survenue ...'));

              } else if (snapshot.hasData) {

                try {
                  print('\n#########################\n');
                  var obj = jsonDecode(snapshot.data);
                  var from = obj['activities'][0]['from']['id'];
                  int? w;

                  if(from!='user') {
                    w = int.tryParse(obj['watermark']);
                  }

                  print(obj);

                  if((from =="user") || (w != widget.watermark)) {
                    messages.add(ChatMessage(
                        content: obj['activities'][0]['text'],
                        from: from));
                    if(from!='user' && w!=null)
                      widget.watermark = w;
                  }

                } catch(e) {}

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  shrinkWrap: false,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  itemBuilder: (context, index){
                    return messages[index];
                  },
                );

              }else {
                return Center(child: const Text('...'));
              }
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: _msgText,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: _send,
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
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
