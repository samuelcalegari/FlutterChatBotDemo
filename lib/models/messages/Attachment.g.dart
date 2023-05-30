// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Attachment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentListAdapter extends TypeAdapter<AttachmentList> {
  @override
  final int typeId = 2;

  @override
  AttachmentList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttachmentList(
      attachments: (fields[0] as List).cast<Attachment>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttachmentList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentAdapter extends TypeAdapter<Attachment> {
  @override
  final int typeId = 1;

  @override
  Attachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attachment(
      attachmentContentType: fields[0] as int,
      content: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Attachment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.attachmentContentType)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HeroCardAttachmentAdapter extends TypeAdapter<HeroCardAttachment> {
  @override
  final int typeId = 7;

  @override
  HeroCardAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeroCardAttachment(
      text: fields[1] as String,
      images: fields[2] as ImageUrlList,
      title: fields[0] as String,
      actionsList: fields[3] as ActionsList,
    );
  }

  @override
  void write(BinaryWriter writer, HeroCardAttachment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.actionsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroCardAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdaptiveCardAttachmentAdapter
    extends TypeAdapter<AdaptiveCardAttachment> {
  @override
  final int typeId = 8;

  @override
  AdaptiveCardAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdaptiveCardAttachment(
      type: fields[0] as String,
      version: fields[1] as String,
      speak: fields[2] as String,
      body: fields[3] as AdaptiveCardBodyList,
    );
  }

  @override
  void write(BinaryWriter writer, AdaptiveCardAttachment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.speak)
      ..writeByte(3)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveCardAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdaptiveCardBodyListAdapter extends TypeAdapter<AdaptiveCardBodyList> {
  @override
  final int typeId = 9;

  @override
  AdaptiveCardBodyList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdaptiveCardBodyList(
      bodyList: (fields[0] as List).cast<AdaptiveCardBody>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdaptiveCardBodyList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.bodyList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveCardBodyListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdaptiveCardBodyAdapter extends TypeAdapter<AdaptiveCardBody> {
  @override
  final int typeId = 10;

  @override
  AdaptiveCardBody read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdaptiveCardBody(
      type: fields[0] as String,
      text: fields[1] as String?,
      columns: (fields[2] as List?)?.cast<dynamic>(),
      items: (fields[3] as List?)?.cast<dynamic>(),
      actions: (fields[4] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdaptiveCardBody obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.columns)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.actions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveCardBodyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
