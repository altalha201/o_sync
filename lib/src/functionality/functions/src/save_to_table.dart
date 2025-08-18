// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Saves [data] to the given [OSyncTable].
///
/// Supports both [OSyncTableType.downloadTable] and [OSyncTableType.uploadTable].
/// Returns:
/// - [Right(true)] if the data was successfully saved.
/// - [Left(error)] if an exception occurs.
Future<Either<dynamic, bool>> osSaveToTable({
  required OSyncTable table,
  required Map<String, dynamic> data,
}) async {
  try {
    switch (table.tableType) {
      case OSyncTableType.downloadTable:
        return _saveToDownloadTable(table, data);

      case OSyncTableType.uploadTable:
        return _saveToUploadTable(table, data);

      default:
        throw Exception('Unsupported table type: ${table.tableType}');
    }
  } catch (e, stackTrace) {
    Logger.error("Failed to save to table ${table.label}: $e\n$stackTrace");
    return Left(e);
  }
}

/// Saves a row of data to a [OSDownloadTable].
Future<Either<dynamic, bool>> _saveToDownloadTable(
  OSyncTable table,
  Map<String, dynamic> data,
) async {
  final hiveTable =
      HiveBoxes.downloadTable.get(table.id) ??
      OSDownloadTable(
        tableKey: table.id,
        tableName: table.label,
        lastUpdated: DateTime.now(),
        rows: [],
      );

  final nextIndex =
      hiveTable.rows.isEmpty
          ? 1
          : hiveTable.rows
                  .map((e) => e.index)
                  .fold<int>(0, (p, e) => e > p ? e : p) +
              1;

  hiveTable.rows.add(OSDownloadData(index: nextIndex, data: data));
  hiveTable.lastUpdated = DateTime.now();

  await hiveTable.saveToHive();

  Logger.plain("Saved row to download table ${table.label} (index $nextIndex)");
  return const Right(true);
}

/// Saves a row of data to an [OSUploadTable].
Future<Either<dynamic, bool>> _saveToUploadTable(
  OSyncTable table,
  Map<String, dynamic> data,
) async {
  final hiveTable =
      HiveBoxes.uploadTable.get(table.id) ??
      OSUploadTable(tableKey: table.id, tableName: table.label, rows: []);

  final nextId =
      hiveTable.rows.isEmpty
          ? 1
          : hiveTable.rows
                  .map((e) => e.id)
                  .fold<int>(0, (p, e) => e > p ? e : p) +
              1;

  hiveTable.rows.add(OSUploadData(id: nextId, data: data));

  await hiveTable.saveToHive;

  Logger.plain("Saved row to upload table ${table.label} (id $nextId)");
  return const Right(true);
}
