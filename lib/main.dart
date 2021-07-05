import 'package:flutter/material.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/screens/loginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.APP_NAME,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}