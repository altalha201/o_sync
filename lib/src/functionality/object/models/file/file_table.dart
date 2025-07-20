import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/constants/hive.dart';

part 'file_table.g.dart';

@HiveType(typeId: HiveBoxType.fileTAble)
class OSFileTable extends HiveObject {
  @HiveField(0)
  int index;

  @HiveField(1)
  String path;

  @HiveField(2)
  bool uploaded;

  OSFileTable({required this.index, required this.path, this.uploaded = false});

  factory OSFileTable.fromRawJson(String source) =>
      OSFileTable.fromJson(json.decode(source));

  factory OSFileTable.fromJson(Map<String, dynamic> json) => OSFileTable(
    index: json[_Json.index],
    path: json[_Json.path],
    uploaded: json[_Json.synced],
  );

  @override
  String toString() => toRawJson;
}

extension SyncImageTableExt on OSFileTable {
  Map<String, dynamic> get toJson => {
    _Json.index: index,
    _Json.path: path,
    _Json.synced: uploaded,
  };

  String get toRawJson => json.encode(toJson);

  Future<void> get saveToHive async {
    final box = HiveBoxes.fileTable;
    await box.put(index, this);
  }

  OSFileTable get withSynced =>
      OSFileTable(index: index, path: path, uploaded: true);
}

class _Json {
  static const String index = 'index';
  static const String path = 'path';
  static const String synced = 'synced';
}
