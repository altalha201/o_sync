// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OSDownloadTableAdapter extends TypeAdapter<OSDownloadTable> {
  @override
  final typeId = 5003;

  @override
  OSDownloadTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSDownloadTable(
      tableKey: (fields[0] as num).toInt(),
      tableName: fields[1] as String,
      lastUpdated: fields[2] as DateTime,
      rows:
          fields[3] == null
              ? const []
              : (fields[3] as List).cast<OSDownloadData>(),
    );
  }

  @override
  void write(BinaryWriter writer, OSDownloadTable obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tableKey)
      ..writeByte(1)
      ..write(obj.tableName)
      ..writeByte(2)
      ..write(obj.lastUpdated)
      ..writeByte(3)
      ..write(obj.rows);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSDownloadTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OSDownloadDataAdapter extends TypeAdapter<OSDownloadData> {
  @override
  final typeId = 5002;

  @override
  OSDownloadData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSDownloadData(
      index: (fields[0] as num).toInt(),
      data: (fields[1] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OSDownloadData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSDownloadDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
