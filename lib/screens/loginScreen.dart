import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:chatdemo/models/CustomException.dart';
import 'package:chatdemo/screens/loginQRCodeScreen.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/User.dart';
import 'package:chatdemo/screens/chatScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();

  // Retrieve user from login and password, redirect to char view
  Future<void> _auth() async {
    final url = APIConstants.MOODLE_BASE_URL +
        APIOperations.getTokenByLoginMoodle +
        '&username=' +
        _login.text +
        '&password=' +
        _password.text;

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      dynamic data = jsonDecode(resp.body);
      var token = data["token"];

      if (token != null) {
        final url = APIConstants.MOODLE_BASE_URL +
            APIOperations.fetchUserDetailMoodle +
            '&wstoken=' +
            token;

        final resp = await http.get(Uri.parse(url));

        if (resp.statusCode == 200) {
          User u = User.fromJson(jsonDecode(resp.body));

          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => new ChatScreen(user: u)),
          );
        } else {
          throw CustomException('Impossible de se connecter au serveur');
        }
      } else {
        throw CustomException('Les identifiants sont incorrects');
      }
    } else {
      throw CustomException('Impossible de se connecter au serveur');
    }
  }

  // Email / Login Field Widget
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Identifiant',
          style: Styles.kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Styles.kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _login,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle_rounded,
                color: Colors.black26,
              ),
              hintText: 'Saisissez votre identifiant',
              hintStyle: Styles.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Password field Widget
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de passe',
          style: Styles.kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Styles.kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: _password,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black26,
              ),
              hintText: 'Saisissez votre mot de passe',
              hintStyle: Styles.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Login button Widget
  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
              try {
                await _auth();
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Désolé...'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(e.toString()),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
              ;
            },
            style: Styles.KButtonStyle,
            child: Text('Se Connecter')));
  }

  Widget _buildLoginQRCodeBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LoginQRCodeScreen()),
              );
            },
            style: Styles.KButtonStyle,
            child: Text('Se Connecter via QRCode')));
  }

  // Build Login Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
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
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  image: AssetImage('assets/img/robot.png')))),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildLoginBtn(),
                      _buildLoginQRCodeBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
