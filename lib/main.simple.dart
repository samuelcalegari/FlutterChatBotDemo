import 'package:flutter/material.dart';
import 'package:chatdemo/chatMessageModel.simple.dart';


void main() {
  runApp(MyApp());
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Bonjour, Samuel", messageType: "receiver"),
    ChatMessage(messageContent: "En quoi puis-je t'aider?", messageType: "receiver"),
    ChatMessage(messageContent: "Quels sont les devoirs à rendre cette semaine?", messageType: "sender"),
    ChatMessage(messageContent: "Keep cool !, pas de devoirs prévus.", messageType: "receiver"),
    ChatMessage(messageContent: "Merci!", messageType: "sender"),
  ];

  final TextEditingController _msgText = TextEditingController();
  final ScrollController _scrollController = ScrollController();

   _sendMessage() {

    setState(() {

      if (_msgText.text.isNotEmpty) {
      // Add Message
      messages.add(ChatMessage(messageContent: _msgText.text, messageType: "sender"));

      // Remove Focus on Text Input
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      }

      // Scroll to Bottom
      _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn
      );

      // Clear Text Input
      _msgText.text = '';
      }
    });
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
            Container(
              padding: EdgeInsets.only(bottom: 50.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                shrinkWrap: false,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(top: 10,bottom: 10),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(left: 14,right: 14,top: 8,bottom: 8),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(messages[index].messageContent, style: TextStyle(fontSize: 12),),
                      ),
                    ),
                  );
                },
              ),
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
                      onPressed: _sendMessage,
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
