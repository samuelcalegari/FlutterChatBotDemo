import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/loginQRCodeScreen.dart';
import '../utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool needAutoLog = false;
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();
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
                            width: context.width() / 1.5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //   _buildEmailTF(),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  //  _buildPasswordTF(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _buildSaveCredCheckbox(),
                                  _buildLoginBtn(),
                                  _buildLoginQRCodeBtn(),
                                ]),
                          ).expand(),
                        ]),
                  ),
                ]))));
  }

  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
              try {
                //await _auth(_login.text, _password.text);
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

  Widget _buildSaveCredCheckbox() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CheckboxListTile(
            checkColor: Colors.white,
            tileColor: Colors.white,
            selectedTileColor: Colors.transparent,
            activeColor: Colors.transparent,
            title: Text("Se souvenir de moi",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white)),
            value: needAutoLog,
            onChanged: (newValue) {
              setState(() {
                needAutoLog = newValue ?? false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.platform, //  <-- leading Checkbox
          )
        ]);
  }
}
