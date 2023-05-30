import 'package:chatdemo/models/User.dart';
import 'package:chatdemo/screens/ChatScreen.dart';
import 'package:chatdemo/utilities/bot_dispatcher_manager.dart';
import 'package:chatdemo/utilities/notification_service.dart';
import 'package:chatdemo/utilities/pref_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/loginScreen.dart';
import 'screens/splash_screen.dart';

late final FlutterSecureStorage storage;
late final PreferenceManager preferenceManager;
late final BotsManager botsManager;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  storage = new FlutterSecureStorage();
  preferenceManager = PreferenceManager();
  botsManager = BotsManager();
  await NotificationService().setup(); // <----

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CupertinoPageRoute getPageRoute(
      {required bool fullscreenDialog, required Widget child}) {
    return CupertinoPageRoute(
      fullscreenDialog: fullscreenDialog,
      builder: (context) {
        return child;
      },
    );
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoute.tagSplashView:
        return getPageRoute(fullscreenDialog: false, child: SplashScreen());
      case NavigationRoute.tagLoginView:
        return getPageRoute(fullscreenDialog: false, child: LoginScreen());
      case NavigationRoute.tagChatView:
        return getPageRoute(
            fullscreenDialog: false,
            child: NewChatScreen(user: settings.arguments as User));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.APP_NAME,
      debugShowCheckedModeBanner: false,
      initialRoute: NavigationRoute.tagSplashView,
      onGenerateRoute: generateRoute,
    );
  }
}
