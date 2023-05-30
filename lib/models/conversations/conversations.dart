import 'package:hive/hive.dart';

class Conversation {
  final String streamUrl;
  final String conversationId;
  String? token;
  Conversation({
    required this.streamUrl,
    required this.conversationId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    print(json);
    return Conversation(
        conversationId: json['conversationId'], streamUrl: json['streamUrl']);
  }
}
