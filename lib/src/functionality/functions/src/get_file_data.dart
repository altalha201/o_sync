// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Retrieves all files stored in the Hive file table as `OSyncData<OSFileTable>`.
///
/// [tableName] is used as the label for the returned data.
/// Returns an `Either` containing the data or an error.
Future<Either<dynamic, OSyncData<OSFileTable>>> osGetFileTable({
  required String tableName,
}) async {
  try {
    final box = HiveBoxes.fileTable;

    // Safely cast Hive values to OSFileTable
    final fileTables = box.values.toList().cast<OSFileTable>();

    final result = OSyncData<OSFileTable>(
      tableName: tableName.snakeCase,
      tableData: fileTables,
      tableId: 0,
    );

    return Right(result);
  } catch (e, stackTrace) {
    Logger.error('Failed to get file table: $e\n$stackTrace');
    return Left(e);
  }
}
