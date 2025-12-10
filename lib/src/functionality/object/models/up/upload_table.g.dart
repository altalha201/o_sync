// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OSUploadTableAdapter extends TypeAdapter<OSUploadTable> {
  @override
  final typeId = 5006;

  @override
  OSUploadTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSUploadTable(
      tableKey: (fields[0] as num).toInt(),
      tableName: fields[1] as String,
      rows: (fields[2] as List?)?.cast<OSUploadData>(),
    );
  }

  @override
  void write(BinaryWriter writer, OSUploadTable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tableKey)
      ..writeByte(1)
      ..write(obj.tableName)
      ..writeByte(2)
      ..write(obj.rows);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSUploadTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OSUploadDataAdapter extends TypeAdapter<OSUploadData> {
  @override
  final typeId = 5005;

  @override
  OSUploadData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSUploadData(
      id: (fields[0] as num).toInt(),
      uploaded: fields[1] == null ? false : fields[1] as bool,
      data: (fields[2] as Map?)?.cast<String, Object?>(),
      files: (fields[3] as Map?)?.cast<String, File>(),
    );
  }

  @override
  void write(BinaryWriter writer, OSUploadData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uploaded)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSUploadDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
