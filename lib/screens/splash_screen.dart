import 'package:chatdemo/main.dart';
import 'package:chatdemo/utilities/bot_dispatcher_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:chatdemo/models/messages/Action.dart' as MessageAction;

import '../models/User.dart';
import '../models/messages/Attachment.dart';
import '../models/messages/ImageUrl.dart';
import '../models/messages/Message.dart';
import '../utilities/api_manager.dart';
import '../utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void registerHive() {
    //message
    Hive.registerAdapter<Message>(MessageAdapter());

    //attachment
    Hive.registerAdapter<Attachment>(AttachmentAdapter());
    Hive.registerAdapter<AttachmentList>(AttachmentListAdapter());

    //attachmentType
    Hive.registerAdapter<HeroCardAttachment>(HeroCardAttachmentAdapter());
    Hive.registerAdapter<AdaptiveCardAttachment>(
        AdaptiveCardAttachmentAdapter());
    Hive.registerAdapter<AdaptiveCardBodyList>(AdaptiveCardBodyListAdapter());
    Hive.registerAdapter<AdaptiveCardBody>(AdaptiveCardBodyAdapter());

    Hive.registerAdapter<MessageAction.ActionsList>(
        MessageAction.ActionsListAdapter());
    Hive.registerAdapter<ImageUrl>(ImageUrlAdapter());
    Hive.registerAdapter<ImageUrlList>(ImageUrlListAdapter());

    Hive.registerAdapter<MessageAction.Action>(MessageAction.ActionAdapter());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var moodleToken = await ApiManager.getMoodleToken();
      if (moodleToken != null) {
        await botsManager.getBotList(moodleToken);
        var test = await storage.read(key: StorageKey.KEY_QRCODE_URI);
        if (test != null) {
          var savedUri = Uri.tryParse(test);
          if (savedUri != null) {
            try {
              //Si l'user se deconnecte, ça va essayer de re initialiser les adapters et hive et crash
              await Hive.initFlutter();
              registerHive();
            } catch (e) {}

            User? user = await ApiManager.authFromQrCode(savedUri, false);
            Navigator.pushReplacementNamed(context, NavigationRoute.tagChatView,
                arguments: user);
            return;
          }
        }
        ;

        Navigator.pushReplacementNamed(context, NavigationRoute.tagLoginView);
        return;
        var uriPath = await storage.read(key: StorageKey.KEY_QRCODE_URL_PATH);
        var uriUserId = await storage.read(key: StorageKey.KEY_QRCODE_USER_ID);
        Uri uri = Uri(path: uriPath, queryParameters: {"userId": uriUserId});
        User? user = await ApiManager.authFromQrCode(uri, false);
        if (user != null) {
          Navigator.pushReplacementNamed(context, NavigationRoute.tagChatView,
              arguments: user);
        } else {
          Navigator.pushReplacementNamed(context, NavigationRoute.tagLoginView);
        }
      }
      // if (await preferenceManager.checkIfAutoAuth()) {
      //   var email =
      //       await preferenceManager.getPref(value: StorageKey.KEY_CRED_LOGIN);
      //   var pswd =
      //       await preferenceManager.getPref(value: StorageKey.KEY_CRED_LOGIN);
      // } else {
      //   Future.delayed(500.milliseconds, () {
      //     Navigator.pushReplacementNamed(context, NavigationRoute.tagLoginView);
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF03A9F4),
                          Color(0xFF049CE0),
                          Color(0xFF038CC9),
                          Color(0xFF0374A7),
                        ],
                        stops: [0.1, 0.4, 0.7, 0.9],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Hero(
                              tag: "logoImg",
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: kToolbarHeight,
                                  child: Image.asset("assets/img/robot.png")),
                            ),
                          ).expand(),
                          Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  PlatformCircularProgressIndicator(
                                    material: (context, platform) =>
                                        MaterialProgressIndicatorData(
                                            color: Colors.white),
                                  )
                                ]),
                          ).expand(),
                        ]),
                  ),
                ]))));
  }
}
