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

  Map<String,Color> _getColors(t) {

    Map<String, Color> c = new Map();

    switch (t) {
      case 'assign':
        {
          c['start'] = const Color(0xFFFF6633);
          c['end'] = const Color(0xFFFF9933);
        }
        break;

      case 'zoom':
        {
          c['start'] = const Color(0xFF50C728);
          c['end'] = Color(0xFF99FF33);
        }
        break;

      default:
        {
          c['start'] = const Color(0xFF3366FF);
          c['end'] = Color(0xFF0099FF);
        }
        break;
    }

    return c;
  }

  BoxDecoration _getHeaderDecoration(t) {

    Map<String, Color> c = _getColors(t);

    return new BoxDecoration(
      gradient: new LinearGradient(
          colors: [
            c["start"]!,
            c["end"]!,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    );
  }

  CircleAvatar _getIcon(t) {

    Map<String, Color> c = _getColors(t);

    IconData ico;

    switch (t) {
      case 'assign':
        {
          ico = Icons.school;
        }
        break;

      case 'zoom':
        {
          ico = Icons.video_call;
        }
        break;

      default:
        {
          ico = Icons.info;
        }
        break;
    }

    return CircleAvatar(
      backgroundColor: c["start"],
      radius: 30,
      child: Icon(ico, color: Colors.white,),
    );
  }

  List<Widget> _buildButtons(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList.add(new ElevatedButton(
          onPressed: () => {
                (l[i].type == "openUrl")
                    ? launch(l[i].value)
                    : sendAction(l[i].value)
              },
          child: Text(l[i].title)));
    }
    return buttonsList;
  }

  List<Widget> _buildButtons2(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList.add(new ElevatedButton(
          onPressed: () => {
                (l[i].type == "Action.OpenUrl")
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
                          decoration: _getHeaderDecoration('default'),
                          child: Text(
                            cardsinfos[index].title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                          decoration:
                              _getHeaderDecoration(cardsinfos[index].template),
                          child: Text(
                            cardsinfos[index].title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        /*Container(
                          width: 300,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            cardsinfos[index].text,
                            textAlign: TextAlign.center,
                          ),
                        ),*/
                        Container(
                            width: 300,
                            padding: EdgeInsets.all(20),
                            child: _getIcon(cardsinfos[index].template)),
                        Container(
                            width: 300,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              cardsinfos[index].subElement1,
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: 300,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                            child: Text(
                              cardsinfos[index].subElement2,
                              textAlign: TextAlign.center,
                            )),
                        Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: _buildButtons2(cardsinfos[index].actions))
                      ],
                    )),
              );
          }),
    );
  }
}
