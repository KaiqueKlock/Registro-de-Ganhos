// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ganho.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GanhoAdapter extends TypeAdapter<Ganho> {
  @override
  final int typeId = 0;

  @override
  Ganho read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ganho(
      value: fields[1] as double,
      description: fields[2] as String,
      data: fields[0] as DateTime,
      id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ganho obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GanhoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
