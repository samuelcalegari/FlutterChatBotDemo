import 'package:chatdemo/models/messages/Attachment.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ActionModel.dart';
import 'messages/Message.dart';

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

  Map<String, Color> _getColors(t) {
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
      child: Icon(
        ico,
        color: Colors.white,
      ),
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
    if (cardsinfos.isEmpty) {
      return Card(
          child: ListTile(
        title: Text("Impossible d'afficher les pièces jointes"),
      )).paddingAll(16);
    }
    return Column(
      children: [
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cardsinfos.map((e) {
                if (e.type == 'application/vnd.microsoft.card.hero') {
                  return getHeroCard();
                }
                return Container(
                  width: context.width() / 1.5,
                  child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          if (e.urlImage != null)
                            Container(
                              alignment: Alignment.center,
                              child: new AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  e.urlImg,
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
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: _getHeaderDecoration(e.template),
                            child: Text(
                              e.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              e.text,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (e.template != null)
                            Container(
                                padding: EdgeInsets.all(20),
                                child: _getIcon(e.template)),
                          if (e.subElement1 != null)
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  e.subElement1,
                                  textAlign: TextAlign.center,
                                )),
                          if (e.subElement2 != null)
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                                child: Text(
                                  e.subElement2,
                                  textAlign: TextAlign.center,
                                )),
                          if (e.actions != null)
                            Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: _buildButtons2(e.actions))
                        ],
                      )),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
    Container(
      height: 500,
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
                        Container(
                          width: 300,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            cardsinfos[index].text,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (cardsinfos[index].template != null)
                          Container(
                              width: 300,
                              padding: EdgeInsets.all(20),
                              child: _getIcon(cardsinfos[index].template)),
                        if (cardsinfos[index].subElement1 != null)
                          Container(
                              width: 300,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                cardsinfos[index].subElement1,
                                textAlign: TextAlign.center,
                              )),
                        if (cardsinfos[index].subElement2 != null)
                          Container(
                              width: 300,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                              child: Text(
                                cardsinfos[index].subElement2,
                                textAlign: TextAlign.center,
                              )),
                        if (cardsinfos[index].actions != null)
                          Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children:
                                  _buildButtons2(cardsinfos[index].actions))
                      ],
                    )),
              );
          }),
    );
  }

  Widget getHeroCard() {
    return Text("hero");
  }
}

class MessageAttachmentCardWidget extends StatefulWidget {
  MessageAttachmentCardWidget(
      {Key? key, required this.message, required this.sendAction})
      : super(key: key);
  Message message;
  final Function(String) sendAction;

  @override
  State<MessageAttachmentCardWidget> createState() =>
      _MessageAttachmentCardWidgetWidgetState();
}

class _MessageAttachmentCardWidgetWidgetState
    extends State<MessageAttachmentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: getListWidget(widget.message.attachments));
  }

  Widget getListWidget(AttachmentList attachmentList) {
    return Column(children: [
      Container(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: attachmentList.attachments.map((e) {
                  if (e.content is HeroCardAttachment) {
                    return getHeroCardWidget(e.content as HeroCardAttachment);
                  } else if (e.content is AdaptiveCardAttachment) {
                    return getAdaptiveCardWidget(
                        e.content as AdaptiveCardAttachment);
                  } else {
                    return Card(
                        child: ListTile(
                      title: Text("Impossible d'afficher les pièces jointes"),
                    )).paddingAll(16);
                  }
                }).toList(),
              )))
    ]);
  }

  Widget getAdaptiveCardWidget(AdaptiveCardAttachment adaptiveCardAttachment) {
    String? template;
    String? se1;
    String? se2;
    String? url;

    try {
      se1 = adaptiveCardAttachment.body.bodyList[4].columns?[0]['items'][0]
              ['text'] +
          '\n' +
          adaptiveCardAttachment.body.bodyList[4].columns?[0]['items'][1]
              ['text'];
      se2 = adaptiveCardAttachment.body.bodyList[4].columns?[1]['items'][0]
              ['text'] +
          '\n' +
          adaptiveCardAttachment.body.bodyList[4].columns?[1]['items'][1]
              ['text'];
      url = adaptiveCardAttachment.body.bodyList[5].actions?[0]['url'];
      var re = RegExp(r'(?<=mod\/)(.*)(?=\/view)');
      if (url != null) {
        var match = re.firstMatch(url);
        template = (match != null) ? match.group(0) : "default";
      }
    } catch (e) {}

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: _getHeaderDecoration(template),
              child: adaptiveCardAttachment.body.bodyList[1].text != null
                  ? Text(
                      adaptiveCardAttachment.body.bodyList[1].text!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  : null,
            )),
        if (adaptiveCardAttachment.body.bodyList[3].text != null)
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              adaptiveCardAttachment.body.bodyList[3].text!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
          ),
        if (template != null) Container(child: _getIcon(template)),
        if (se1 != null)
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                se1,
                textAlign: TextAlign.center,
              )),
        if (se2 != null)
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                se2,
                textAlign: TextAlign.center,
              )),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _buildButtons2([
              if (url != null)
                ActionInfos(
                    type: adaptiveCardAttachment.body.bodyList[5].actions?[0]
                        ['type'],
                    title: adaptiveCardAttachment.body.bodyList[5].actions?[0]
                        ['title'],
                    value: url)
            ]))),
      ]),
    ).withWidth(context.width() / 1.5);
    return Text(adaptiveCardAttachment.type);
  }

  Widget getHeroCardWidget(HeroCardAttachment heroCardAttachment) {
    print("template");
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(children: [
        if (heroCardAttachment.images.imgs.isNotEmpty)
          Container(
              alignment: Alignment.center,
              child: new AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: Image.network(
                    heroCardAttachment.images.imgs.first.url,
                    cacheWidth: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: _getHeaderDecoration(null),
          child: Text(
            heroCardAttachment.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            heroCardAttachment.text,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall,
          ),
        ),
        if (heroCardAttachment.actionsList.actions.isNotEmpty)
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children:
                      _buildButtons2(heroCardAttachment.actionsList.actions))),
      ]),
    ).withWidth(context.width() / 1.5);
    return Column(
      children: [
        if (heroCardAttachment.images.imgs.isNotEmpty)
          Container(
            width: 300,
            alignment: Alignment.center,
            child: new AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                heroCardAttachment.images.imgs.first.url,
                cacheWidth: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        Text(
          heroCardAttachment.text,
        ),
      ],
    );
  }

  Map<String, Color> _getColors(t) {
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
      child: Icon(
        ico,
        color: Colors.white,
      ),
    );
  }

  List<Widget> _buildButtons(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList.add(new ElevatedButton(
          onPressed: () => {
                (l[i].type == "openUrl")
                    ? launch(l[i].value)
                    : widget.sendAction(l[i].value)
              },
          child: Text(l[i].title)));
    }
    return buttonsList;
  }

  List<Widget> _buildButtons2(l) {
    List<Widget> buttonsList = [];
    for (int i = 0; i < l.length; i++) {
      buttonsList.add(
        ActionChip(
          label: Text(l[i].title),
          onPressed: () => {
            (l[i].type == "Action.OpenUrl")
                ? launch(l[i].value)
                : widget.sendAction(l[i].value)
          },
        ).paddingSymmetric(horizontal: 4),
      );
    }
    return buttonsList;
  }
}
