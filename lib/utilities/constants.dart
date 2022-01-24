import 'package:flutter/material.dart';

class Config {
  static const String APP_NAME = "Miro Bot";
}

class APIConstants {
  static const String BOTAVATAR = "https://forco.univ-perp.fr/theme/forco/bot/bot.png";
  static const String MOODLE_BASE_URL = "https://forco.univ-perp.fr/";
  static const String DIRECTLINE_BASE_URL = "https://directline.botframework.com/v3/directline/";
  static const String DIRECTLINE_SECRET = "ur2eVWbMew8.5nEjH6LT8mVIqUXmis9ixQ8kwFNheqIr8pclXlNrThQ";
}

class APIOperations {

  static final String fetchUserDetailMoodle  = "webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json";
  static final String fetchUserDetailMoodleFromField = "webservice/rest/server.php?wsfunction=core_user_get_users_by_field&moodlewsrestformat=json";
  static final String getTokenByQrCode  = "webservice/rest/server.php?wsfunction=tool_mobile_get_tokens_for_qr_login&moodlewsrestformat=json";
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

  static final kTitleStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.bold,
    fontSize: 20,
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