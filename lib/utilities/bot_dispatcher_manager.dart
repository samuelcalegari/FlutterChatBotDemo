import 'dart:convert';
import 'dart:io';

import 'package:chatdemo/models/dispatcher/BotDispatcherList.dart';
import 'package:chatdemo/utilities/api_manager.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:http/http.dart' as http;

class BotsManager {
  String? moodleToken;

  BotList? botList;
  Bots? selectedBot;
  String? streamUrl;
  BotsManager();

  Future getBotList(String moodleToken) async {
    this.moodleToken = moodleToken;
    botList = await ApiManager.getBotList(moodleToken);
  }

  Bots? getBotForUri({String? path}) {
    if (path != null) {
      botList?.bots?.forEach((element) {
        if (element.moodleUrl?.contains(path) == true) {
          this.selectedBot = element;
        }
      });
    }

    return this.selectedBot;
  }

  Future<String?> getStreamUrl() async {
    if (selectedBot != null && selectedBot!.directlineSecret != null) {
      final response = await http.post(
        Uri.parse(
            APIConstants.DIRECTLINE_BASE_URL + APIOperations.getConversation),
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + this.selectedBot!.directlineSecret!,
        },
      );

      final responseJson = jsonDecode(response.body);

      this.selectedBot?.streamUrl = responseJson['streamUrl'];

      this.selectedBot?.conversationId = responseJson['conversationId'];

      return this.selectedBot?.streamUrl;
    }
    return null;
  }
}
