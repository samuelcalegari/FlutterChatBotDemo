import 'package:chatdemo/main.dart';
import 'package:chatdemo/screens/components/chat_list_widget.dart';
import 'package:chatdemo/screens/loginScreen.dart';
import 'package:chatdemo/screens/ChatScreen.dart';
import 'package:chatdemo/utilities/alert_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/User.dart';
import 'package:hive/hive.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //pour avoir le bouton retour, il est blanc par défault (avec fond bleu), iconTheme pour le remettre noir, et le reste pr pas qu'on voti la barre
        appBar: AppBar(
          title: Text("Paramètres", style: context.theme.textTheme.titleLarge),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 120.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: NetworkImage(user.userPictureUrl)))),
                    SizedBox(height: 30.0),
                    Text(user.firstName + ' ' + user.lastName,
                        style: Styles.kTitleStyle),
                    SizedBox(height: 30.0),
                    _buildConvInfo(context),
                    _buildDelHistoryBtn(context),
                    _buildLogoutBtn(context),
                  ],
                ),
              )),
        ));
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
              radius: 16,
              onTap: () {
                storage.deleteAll();
                Navigator.of(context)
                    .pushReplacementNamed(NavigationRoute.tagSplashView);
              },
              child: ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  horizontalTitleGap: 0,
                  title: Text("Déconnexion",
                      style: context.theme.textTheme.labelLarge)))
          .cornerRadiusWithClipRRect(16),
    );
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              storage.deleteAll();
              Navigator.of(context)
                  .pushReplacementNamed(NavigationRoute.tagSplashView);
            },
            style: Styles.KButtonStyle,
            child: Text('Se Déconnecter')));
  }

  Widget _buildConvInfo(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          onTap: () {
            var value = "";
            if (NewChatScreen
                    .widgetKey.currentState?.conversationInfo.conversationId !=
                null) {
              value = value +
                  " Conversation id : " +
                  NewChatScreen
                      .widgetKey.currentState!.conversationInfo.conversationId;
            }
            if (botsManager.moodleToken != null) {
              value = value +
                  "\n \n \n  Moodle id id : " +
                  botsManager.moodleToken!;
            }
            AlertManager.showAlertDialog(
                callback: (isOk) {},
                context: context,
                title: "Information",
                content: value,
                cancelActionText: "Annuler",
                defaultActionText: "Valider");
          },
          child: ListTile(
              leading: Icon(
                Icons.data_array,
              ),
              horizontalTitleGap: 0,
              title: Text("Informations de la conversation",
                  style: context.theme.textTheme.labelLarge))),
    );

    return Container(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
              ChatListWidget.widgetKey.currentState?.cleanHistory();
            },
            style: Styles.KButtonStyle,
            child: Text("Supprimer l'historique de la conversation")));
  }

  Widget _buildDelHistoryBtn(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          onTap: () {
            AlertManager.showAlertDialog(
                callback: (isOk) {
                  if (isOk) {
                    ChatListWidget.widgetKey.currentState?.cleanHistory();
                  }
                },
                context: context,
                title: "Attention",
                content: "La suppression est irréversible",
                cancelActionText: "Annuler",
                defaultActionText: "Valider");
          },
          child: ListTile(
              leading: Icon(
                Icons.delete,
              ),
              horizontalTitleGap: 0,
              title: Text("Supprimer l'historique de la conversation",
                  style: context.theme.textTheme.labelLarge))),
    );

    return Container(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
              ChatListWidget.widgetKey.currentState?.cleanHistory();
            },
            style: Styles.KButtonStyle,
            child: Text("Supprimer l'historique de la conversation")));
  }
}
