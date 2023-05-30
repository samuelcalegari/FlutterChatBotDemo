import 'package:chatdemo/models/messages/Action.dart';
import 'package:chatdemo/models/messages/ImageUrl.dart';
import 'package:hive/hive.dart';
part 'Attachment.g.dart';

enum AttachmentContentType { HeroCard, Card }

@HiveType(typeId: 2)
class AttachmentList {
  @HiveField(0)
  final List<Attachment> attachments;

  AttachmentList({
    required this.attachments,
  });
  AttachmentList.fromJson(List<dynamic> json)
      : attachments = json
            .map((dynamic e) => Attachment.fromJson(e as Map<String, dynamic>))
            .toList();
}

@HiveType(typeId: 1)
class Attachment {
  @HiveField(0)
  final int attachmentContentType;
  @HiveField(1)
  final dynamic content;
  Attachment({
    required this.attachmentContentType,
    required this.content,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    if (json["contentType"] == "application/vnd.microsoft.card.hero") {
      return Attachment(
          content: json['content'] != null
              ? HeroCardAttachment.fromJson(json['content'])
              : null,
          attachmentContentType: AttachmentContentType.HeroCard.index);
    } else {
      return Attachment(
          content: json['content'] != null
              ? AdaptiveCardAttachment.fromJson(json['content'])
              : null,
          attachmentContentType: AttachmentContentType.Card.index);
    }
    return Attachment(
        content: json['content'] != null
            ? AdaptiveCardAttachment.fromJson(json['content'])
            : null,
        attachmentContentType:
            json['contentType'] == 'application/vnd.microsoft.card.hero'
                ? AttachmentContentType.HeroCard.index
                : AttachmentContentType.Card.index);
  }
}

@HiveType(typeId: 7)
class HeroCardAttachment {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final ImageUrlList images;
  @HiveField(3)
  final ActionsList actionsList;
  HeroCardAttachment({
    required this.text,
    required this.images,
    required this.title,
    required this.actionsList,
  });
  factory HeroCardAttachment.fromJson(Map<String, dynamic> json) {
    return HeroCardAttachment(
        text: json["text"] ?? "",
        images: json['images'] != null
            ? ImageUrlList.fromJson(json['images'])
            : ImageUrlList(imgs: []),
        title: json["title"] != null ? json['title'] : "",
        actionsList: json['buttons'] != null
            ? ActionsList.fromJson(json['buttons'])
            : ActionsList(actions: []));
  }
}

@HiveType(typeId: 8)
class AdaptiveCardAttachment {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String version;
  @HiveField(2)
  final String speak;
  @HiveField(3)
  final AdaptiveCardBodyList body;
  AdaptiveCardAttachment({
    required this.type,
    required this.version,
    required this.speak,
    required this.body,
  });
  factory AdaptiveCardAttachment.fromJson(Map<String, dynamic> json) {
    return AdaptiveCardAttachment(
        type: json["type"] ?? "",
        version: json["version"] ?? "",
        speak: json["speak"] != null ? json['speak'] : "",
        body: json['body'] != null
            ? AdaptiveCardBodyList.fromJson(json['body'])
            : AdaptiveCardBodyList(bodyList: []));
  }
}

@HiveType(typeId: 9)
class AdaptiveCardBodyList {
  @HiveField(0)
  final List<AdaptiveCardBody> bodyList;
  AdaptiveCardBodyList({
    required this.bodyList,
  });
  AdaptiveCardBodyList.fromJson(List<dynamic> json)
      : bodyList = json
            .map((dynamic e) =>
                AdaptiveCardBody.fromJson(e as Map<String, dynamic>))
            .toList();
}

@HiveType(typeId: 10)
class AdaptiveCardBody {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String? text;
  @HiveField(2)
  final List<dynamic>? columns;
  @HiveField(3)
  final List<dynamic>? items;
  @HiveField(4)
  final List<dynamic>? actions;
  AdaptiveCardBody(
      {required this.type, this.text, this.columns, this.items, this.actions});
  factory AdaptiveCardBody.fromJson(Map<String, dynamic> json) {
    return AdaptiveCardBody(
      type: json["type"] ?? "",
      text: json["text"],
      columns: json["columns"],
      items: json["items"],
      actions: json["actions"],
    );
  }
}
