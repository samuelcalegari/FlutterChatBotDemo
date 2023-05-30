import 'package:chatdemo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utilities/constants.dart';
import '../chatScreen.dart';
import '../profileScreen.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
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
                    botsManager.selectedBot?.avatar ?? APIConstants.BOTAVATAR),
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
                      botsManager.selectedBot?.name ?? Config.APP_NAME,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      ChatScreen.widgetKey.currentState?.chatStatus ==
                              ChatState.CONNECTED
                          ? "Online"
                          : "Offline",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (ChatScreen.widgetKey.currentState?.getUser() != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              user:
                                  ChatScreen.widgetKey.currentState!.getUser()),
                        ));
                  }
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
