import 'package:flutter/material.dart';

class APIConstants {
  static const String MOODLE_BASE_URL = "https://forco.univ-perp.fr/";
  static const String DIRECTLINE_BASE_URL = "https://directline.botframework.com/v3/directline/";
  static const String BOTAVATAR = "https://forco.univ-perp.fr/theme/forco/bot/bot.png";
}

class APIOperations {

  static final String fetchUserDetailMoodle  = "webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json";
  static final String getTokenByLoginMoodle  = "login/token.php?service=moodle_mobile_app&moodlewsrestformat=json";
  static final String getTokenFromDirectLine = "tokens/generate";
  static final String getConversation = "conversations/";
}

class Styles {

  static final kHintTextStyle = TextStyle(
    color: Colors.black26,
    fontFamily: 'OpenSans',
  );
  static final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
  static final kBoxDecorationStyle = BoxDecoration(
    //color: Color(0xFF03A9F4),
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  static final KButtonStyle = ElevatedButton.styleFrom(
    primary: Color(0xFF03A9F4),
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
    shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),
  );
}