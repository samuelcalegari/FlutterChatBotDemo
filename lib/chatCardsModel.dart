import 'package:flutter/material.dart';

class ChatCards extends StatelessWidget {

  final List<dynamic> cardsinfos;
  final String from;
  final Function(String) sendAction;

  ChatCards(
      {Key? key, required this.cardsinfos, required this.from, required this.sendAction})
      : super(key: key);

  List<Widget> _buildButtons(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList
          .add(new TextButton(
              onPressed: ()=>{sendAction(l[i].value)},
              child: Text(l[i].title))
      );
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: cardsinfos.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Card(
                  elevation:5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(cardsinfos[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.network(cardsinfos[index].urlImg, width: 250, cacheWidth: 250, fit: BoxFit.fill,),
                      ),
                      Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: _buildButtons(cardsinfos[index].actions)
                      )
                      /*
                      TextButton(
                        child: Text('Voir le cours'),
                        onPressed: () {/** */},
                      ),*/
                    ],
                  )
              ),
            );
          }),
    );
  }
}