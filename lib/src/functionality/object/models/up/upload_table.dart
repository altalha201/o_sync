// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'package:hive_ce/hive.dart';
import '../../../../core/constants/hive.dart';

part 'upload_table.g.dart';

/// A Hive model representing a table that holds unsynced upload data.
@HiveType(typeId: HiveBoxType.uploadTable)
class OSUploadTable extends HiveObject {
  @HiveField(0)
  int tableKey;

  @HiveField(1)
  String tableName;

  @HiveField(2)
  List<OSUploadData> rows;

  OSUploadTable({
    required this.tableKey,
    required this.tableName,
    List<OSUploadData>? rows,
  }) : rows = rows ?? [];

  /// Returns a copy of this table with updated rows.
  OSUploadTable withNewData(List<OSUploadData> newRows) =>
      OSUploadTable(tableKey: tableKey, tableName: tableName, rows: newRows);
}

/// A Hive model representing a single row of upload data.
@HiveType(typeId: HiveBoxType.uploadData)
class OSUploadData extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  bool uploaded;

  @HiveField(2)
  Map<String, Object?>? data;

  OSUploadData({required this.id, this.uploaded = false, this.data});

  /// Returns a copy of this object with updated fields.
  OSUploadData copyWith({int? id, bool? uploaded, Map<String, Object?>? data}) {
    return OSUploadData(
      id: id ?? this.id,
      uploaded: uploaded ?? this.uploaded,
      data: data ?? this.data,
    );
  }

  /// Returns a copy of this object marked as synced.
  OSUploadData get withSynced => copyWith(uploaded: true);
}

/// Extension on [OSUploadTable] to persist into Hive.
extension UploadTableExt on OSUploadTable {
  /// Saves the current table instance to Hive.
  Future<void> saveToHive() async {
    final box = HiveBoxes.uploadTable;
    await box.put(tableKey, this);
  }
}
