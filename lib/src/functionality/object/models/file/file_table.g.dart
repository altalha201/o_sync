// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OSFileTableAdapter extends TypeAdapter<OSFileTable> {
  @override
  final typeId = 5004;

  @override
  OSFileTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSFileTable(
      index: (fields[0] as num).toInt(),
      path: fields[1] as String,
      uploaded: fields[2] == null ? false : fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OSFileTable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.uploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSFileTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
