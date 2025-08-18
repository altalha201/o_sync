// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Retrieves all upload tables stored in Hive as a list of [OSyncData].
///
/// Returns [Right] containing a list of [OSyncData<OSUploadData>] on success,
/// or [Left] with an error on failure.
Future<Either<dynamic, List<OSyncData<OSUploadData>>>>
osGetUploadTables() async {
  try {
    final box = HiveBoxes.uploadTable;
    final tables = box.values;

    final List<OSyncData<OSUploadData>> uploadTables =
        tables
            .map(
              (table) => OSyncData(
                tableName: table.tableName,
                tableData: table.rows,
                tableId: table.tableKey,
              ),
            )
            .toList();

    return Right(uploadTables);
  } catch (e, stackTrace) {
    Logger.error("Failed to get upload tables: $e\n$stackTrace");
    return Left(e);
  }
}
