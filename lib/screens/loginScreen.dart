import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/User.dart';
import 'package:chatdemo/screens/chatScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();

  // Retrieve user from login and password, redirect to char view
  void _auth() async {
    final resp = await http.get(Uri.parse(APIConstants.MOODLE_BASE_URL +
        APIOperations.getTokenByLoginMoodle +
        '&username=' +
        _login.text +
        '&password=' +
        _password.text));

    if (resp.statusCode == 200) {
      dynamic data = jsonDecode(resp.body);
      var token = data["token"];

      if (token != null) {
        final resp = await http.get(Uri.parse(APIConstants.MOODLE_BASE_URL +
            APIOperations.fetchUserDetailMoodle +
            '&wstoken=' +
            token));

        if (resp.statusCode == 200) {
          User u = User.fromJson(jsonDecode(resp.body));

          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => new ChatScreen(user: u)),
          );
        } else {
          throw Exception('Unable to connect server');
        }
      } else {
        throw Exception('Failed to login');
      }
    } else {
      throw Exception('Unable to connect server');
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

  // Password lost button Widget
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          'Mot de passe perdu ?',
          style: Styles.kLabelStyle,
        ),
      ),
    );
  }

  // Checkbox Widget
  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Se souvenir de moi',
            style: Styles.kLabelStyle,
          ),
        ],
      ),
    );
  }

  // Login button Widget
  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _auth,
            style: Styles.KButtonStyle,
            child: Text('Se Connecter')));
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
                    vertical: 120.0,
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
                        height: 10.0,
                      ),
                      _buildForgotPasswordBtn(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildRememberMeCheckbox(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildLoginBtn(),
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
