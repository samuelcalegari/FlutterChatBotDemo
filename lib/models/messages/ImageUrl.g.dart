// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ImageUrl.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageUrlListAdapter extends TypeAdapter<ImageUrlList> {
  @override
  final int typeId = 6;

  @override
  ImageUrlList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageUrlList(
      imgs: (fields[0] as List).cast<ImageUrl>(),
    );
  }

  @override
  void write(BinaryWriter writer, ImageUrlList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.imgs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUrlListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageUrlAdapter extends TypeAdapter<ImageUrl> {
  @override
  final int typeId = 5;

  @override
  ImageUrl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageUrl(
      url: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageUrl obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUrlAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
