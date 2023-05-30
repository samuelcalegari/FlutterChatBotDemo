// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActionsListAdapter extends TypeAdapter<ActionsList> {
  @override
  final int typeId = 4;

  @override
  ActionsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionsList(
      actions: (fields[0] as List).cast<Action>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActionsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.actions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActionAdapter extends TypeAdapter<Action> {
  @override
  final int typeId = 3;

  @override
  Action read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Action(
      type: fields[0] as String,
      title: fields[1] as String,
      value: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Action obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
