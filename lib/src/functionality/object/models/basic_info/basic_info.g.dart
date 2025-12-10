// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OSBasicInfoAdapter extends TypeAdapter<OSBasicInfo> {
  @override
  final typeId = 5001;

  @override
  OSBasicInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OSBasicInfo(
      packageName: fields[0] as String,
      baseUrl: fields[1] as String,
      fileUploadPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OSBasicInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.packageName)
      ..writeByte(1)
      ..write(obj.baseUrl)
      ..writeByte(2)
      ..write(obj.fileUploadPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSBasicInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
