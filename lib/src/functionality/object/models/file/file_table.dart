import 'dart:convert';
import 'package:hive_ce/hive.dart';

import '../../../../core/constants/hive.dart';

part 'file_table.g.dart';

/// A Hive model representing a file entry in the offline sync system.
///
/// Each entry corresponds to a file stored locally that may or may not
/// have been uploaded to the server.
@HiveType(typeId: HiveBoxType.fileTable)
class OSFileTable extends HiveObject {
  @HiveField(0)
  int index;

  @HiveField(1)
  String path;

  @HiveField(2)
  bool uploaded;

  OSFileTable({required this.index, required this.path, this.uploaded = false});

  /// Creates an instance from a raw JSON string.
  factory OSFileTable.fromRawJson(String source) =>
      OSFileTable.fromJson(json.decode(source));

  /// Creates an instance from a JSON map.
  factory OSFileTable.fromJson(Map<String, dynamic> json) => OSFileTable(
    index: json[_Json.index] as int,
    path: json[_Json.path] as String,
    uploaded: json[_Json.uploaded] as bool? ?? false,
  );

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => {
    _Json.index: index,
    _Json.path: path,
    _Json.uploaded: uploaded,
  };

  /// Converts this object to a raw JSON string.
  String toRawJson() => json.encode(toJson());

  /// Returns a copy of this object with updated fields.
  OSFileTable copyWith({int? index, String? path, bool? uploaded}) {
    return OSFileTable(
      index: index ?? this.index,
      path: path ?? this.path,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  /// Returns a copy of the file entry marked as synced.
  OSFileTable get withSynced => copyWith(uploaded: true);

  @override
  String toString() => toRawJson();
}

/// Extension methods for persisting [OSFileTable] to Hive.
extension OSFileTableHiveExt on OSFileTable {
  /// Saves the current instance to the Hive file table.
  Future<void> saveToHive() async {
    final box = HiveBoxes.fileTable;
    await box.put(index, this);
  }
}

/// JSON key constants used for [OSFileTable] serialization.
class _Json {
  static const String index = 'index';
  static const String path = 'path';
  static const String uploaded = 'uploaded';
}
