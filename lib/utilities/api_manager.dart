import 'dart:convert';
import 'dart:io';

import 'package:chatdemo/models/TokenSecret.dart';
import 'package:chatdemo/models/conversations/conversations.dart';
import 'package:chatdemo/models/dispatcher/BotDispatcherList.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/CustomException.dart';
import '../models/User.dart';
import 'constants.dart';

class ApiManager {
  // Get Token From Direct Line
  static Future<String?> getToken() async {
    final response = await http.post(
      Uri.parse(APIConstants.DIRECTLINE_BASE_URL +
          APIOperations.getTokenFromDirectLine),
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + APIConstants.DIRECTLINE_SECRET,
      },
    );
    final responseJson = jsonDecode(response.body);
    return responseJson['token'];
  }

// Get WebStream to real-time chat
  static Future<Conversation?> getConversationInfo() async {
    var token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse(
            APIConstants.DIRECTLINE_BASE_URL + APIOperations.getConversation),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
        },
      );

      final responseJson = jsonDecode(response.body);

      var conversation = Conversation.fromJson(responseJson);
      ;
      conversation.token = token;
      return conversation;
    }
    return null;
  }

  static Future<String?> getMoodleToken() async {
    TokenScret moodleCred =
        await SecretLoader(secretPath: "assets/tokenSecret.json").load();
    var response = await http.post(
      Uri.parse(APIConstants.DISPATCHER_URL + "token"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': moodleCred.username,
        'password': moodleCred.password
      }),
    );

    final str = response.headers['set-cookie'];
    final start = 'token=';
    final end = ';';
    final startIndex = str?.indexOf(start);
    if (startIndex != null) {
      final endIndex = str?.indexOf(end, startIndex + start.length);
      var token = str?.substring(startIndex + start.length, endIndex);

      return str?.substring(startIndex + start.length, endIndex);
    }

    return null;
  }

  static Future<BotList> getBotList(String moodleToken) async {
    var response = await http.get(
      Uri.parse(APIConstants.DISPATCHER_URL),
      headers: {'Cookie': "token=" + moodleToken},
    );
    return BotList.fromJson(jsonDecode(response.body));
  }

  static Future<dynamic> setConversationData(
      String moodleToken, String conversationId, String moodleId) async {
    var response = await http.post(
      Uri.parse(
          APIConstants.MOODLE_BASE_URL + APIOperations.setConversationData),
      headers: {'Cookie': "token=" + moodleToken},
      body: jsonEncode(<String, String>{
        'moodleid': moodleId,
        'conversationid': conversationId
      }),
    );
    return response.body;
  }

  static Future<User?> authFromQrCode(Uri uri, bool saveUriData) async {
    if (saveUriData) {
      await storage.write(
          key: StorageKey.KEY_QRCODE_URI, value: uri.toString());

      await storage.write(key: StorageKey.KEY_QRCODE_URL_PATH, value: uri.path);
      await storage.write(
          key: StorageKey.KEY_QRCODE_USER_ID,
          value: uri.queryParameters['userid'].toString());
    }

    Bots? bot = botsManager.getBotForUri(path: uri.path);

    if (bot != null && bot.moodleUser != null && bot.moodlePasswort != null) {
      final url = APIConstants.MOODLE_BASE_URL +
          APIOperations.getTokenByLoginMoodle +
          '&username=' +
          bot.moodleUser! +
          '&password=' +
          bot.moodlePasswort!;

      final resp = await http.get(Uri.parse(url));
      dynamic data = jsonDecode(resp.body);
      var token = data["token"];
      if (token != null) {
        final url = APIConstants.MOODLE_BASE_URL +
            APIOperations.fetchUserDetailMoodleFromField +
            '&field=id' +
            '&values[0]=' +
            Uri.encodeComponent(uri.queryParameters['userid'].toString()) +
            '&wstoken=' +
            token;

        print(url);

        final resp = await http.get(Uri.parse(url));
        print(resp.body);
        if (resp.statusCode == 200) {
          User u = User.fromJson2(jsonDecode(resp.body)[0]);
          return u;
        }
      }
    }
    return null;
  }
}
