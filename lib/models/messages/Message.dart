import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'Action.dart';
import 'Attachment.dart';
part 'Message.g.dart';

@HiveType(typeId: 0)
class Message {
  bool isOldMessage = false;
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String from;
  @HiveField(2)
  final String? text;
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final String watermark;
  @HiveField(5)
  final AttachmentList attachments;
  @HiveField(6)
  final List<Action> suggestedActions;
  @HiveField(7)
  final String? timestamp;
  @HiveField(8)
  final String? attachmentLayout;
  @HiveField(9)
  Message(
      {required this.from,
      required this.id,
      required this.attachments,
      required this.text,
      required this.watermark,
      required this.title,
      required this.attachmentLayout,
      required this.timestamp,
      required this.suggestedActions});

  factory Message.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['activities'][0]['attachments'] != null) {
      var test = AttachmentList.fromJson(json['activities'][0]['attachments']);
      print("fdp");
    }
    return Message(
        id: json['activities'][0]["id"],
        from: json['activities'][0]['from']['id'],
        attachments: json['activities'][0]['attachments'] != null
            ? AttachmentList.fromJson(json['activities'][0]['attachments'])
            : AttachmentList(attachments: []),
        suggestedActions: json['activities'][0]['suggestedActions'] != null
            ? json['activities'][0]['suggestedActions']["actions"]
                .map<Action>((dynamic e) {
                return Action.fromJson(e as Map<String, dynamic>);
              }).toList()
            : [],
        text: json['activities'][0]['text'],
        watermark: json["watermark"] ?? "0",
        attachmentLayout: json["attachmentLayout"] ?? "",
        title: json['activities'][0]['title'],
        timestamp: json['activities'][0]["timestamp"] ?? "");
  }

  int getMessagePosition() {
    var idNumber = this.id.substring(this.id.lastIndexOf('|') + 1);
    try {
      return int.parse(idNumber);
    } catch (e) {
      return 9999;
    }
  }

  DateTime? getDateTime() {
    if (timestamp != null) {
      return DateTime.parse(timestamp!);
    }
    return null;
  }

  String? getFormatedDateToString() {
    if (getDateTime() != null) {
      return DateFormat('dd/MM/yy').format(getDateTime()!);
    }
    return null;
  }

  String? getFormatedTimeToString() {
    if (getDateTime() != null) {
      return DateFormat('hh:mm').format(getDateTime()!);
    }
    return null;
  }

  bool isFromUser() {
    return from == "user";
  }
}
