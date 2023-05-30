import 'dart:convert';

import 'package:chatdemo/main.dart';
import 'package:chatdemo/models/chatScreen%20copy%202.dart';
import 'package:chatdemo/models/messages/Action.dart' as MessageAction;
import 'package:chatdemo/models/messages/Attachment.dart';
import 'package:chatdemo/models/messages/ImageUrl.dart';
import 'package:chatdemo/models/messages/Message.dart';
import 'package:chatdemo/utilities/api_manager.dart';
import 'package:chatdemo/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:chatdemo/models/CustomException.dart';
import 'package:chatdemo/screens/loginQRCodeScreen.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/User.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();
  var needSaveCred = false;

  // Retrieve user from login and password, redirect to char view
  Future<void> _auth(String login, String pwd) async {
    final url = APIConstants.MOODLE_BASE_URL +
        APIOperations.getTokenByLoginMoodle +
        '&username=' +
        login +
        '&password=' +
        pwd;

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
          if (needSaveCred) {
            await saveCred();
          }
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

  Future saveCred() async {
    await storage.write(
        key: StorageKey.KEY_AUTO_AUTH, value: needSaveCred.toString());
    await storage.write(key: StorageKey.KEY_CRED_LOGIN, value: _login.text);
    await storage.write(key: StorageKey.KEY_CRED_PSWD, value: _password.text);
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
                await _auth(_login.text, _password.text);
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
            value: needSaveCred,
            onChanged: (newValue) {
              setState(() {
                needSaveCred = newValue ?? false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.platform, //  <-- leading Checkbox
          )
        ]);
  }

  void checkIfAutoAuth() async {
    var isAutoAuth = await storage.read(key: StorageKey.KEY_AUTO_AUTH);
    if (isAutoAuth == "true") {
      var email = await storage.read(key: StorageKey.KEY_CRED_LOGIN);
      var pswd = await storage.read(key: StorageKey.KEY_CRED_PSWD);
      if (email?.isNullOrEmpty() == false && pswd?.isNullOrEmpty() == false) {
        _auth(email!, pswd!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        //Si l'user se deconnecte, ça va essayer de re initialiser les adapters et hive et crash
        await Hive.initFlutter();
        registerHive();
      } catch (e) {}

      checkIfAutoAuth();
    });
  }

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
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
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
                              width: kToolbarHeight * 2,
                              height: kToolbarHeight * 2,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      image:
                                          AssetImage('assets/img/robot.png')))),
                          SizedBox(height: 30.0),
                          //  _buildEmailTF(),
                          SizedBox(
                            height: 30.0,
                          ),
                          //    _buildPasswordTF(),
                          SizedBox(
                            height: 20.0,
                          ),
                          // _buildSaveCredCheckbox(),
                          //  _buildLoginBtn(),
                          _buildLoginQRCodeBtn(),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
