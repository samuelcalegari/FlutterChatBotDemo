import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatCards extends StatelessWidget {
  final List<dynamic> cardsinfos;
  final String from;
  final Function(String) sendAction;

  ChatCards(
      {Key? key,
      required this.cardsinfos,
      required this.from,
      required this.sendAction})
      : super(key: key);

  List<Widget> _buildButtons(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList.add(new TextButton(
          onPressed: () => {
                (l[i].type == "openUrl")
                    ? launch(l[i].value)
                    : sendAction(l[i].value)
              },
          child: Text(l[i].title)));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: cardsinfos.length,
          itemBuilder: (BuildContext context, int index) {
            if (cardsinfos[index].type == 'application/vnd.microsoft.card.hero')
              return Container(
                child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            cardsinfos[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          child: new AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              cardsinfos[index].urlImg,
                              cacheWidth: 250,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: _buildButtons(cardsinfos[index].actions))
                      ],
                    )),
              );
            else
              return Container(
                child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            cardsinfos[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            cardsinfos[index].text,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                            width: 300,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              cardsinfos[index].subElement1,
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: 300,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              cardsinfos[index].subElement2,
                              textAlign: TextAlign.center,
                            )),
                        Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: _buildButtons(cardsinfos[index].actions))
                      ],
                    )),
              );
          }),
    );
  }
}
