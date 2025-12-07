// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Deletes a row from a table based on its [tableType].
///
/// This function provides a unified API for removing rows from different
/// table storage mechanisms. It is designed so that the table implementation
/// (e.g., Hive, SQLite, memory table, etc.) can be hidden behind abstractions
/// and replaced as needed by the package consumer.
///
/// Returns:
/// - `Right(true)` if the row was successfully deleted.
/// - `Left(error)` if an exception occurred.
///
/// Example:
/// ```dart
/// final result = await deleteRowFromTable(
///   table,
///   12,
/// );
///
/// result.fold(
///   (err) => print("Error: $err"),
///   (ok) => print("Deleted."),
/// );
/// ```
Future<Either<Object, bool>> osDeleteRowFromTable(
    OSyncTable table,
    int id,
    ) async {
  try {
    switch (table.tableType) {
      case OSyncTableType.downloadTable:
        final hiveTable = HiveBoxes.downloadTable.get(table.id);
        if (hiveTable == null) {
          throw StateError("Table not found");
        }

        final index = hiveTable.rows.indexWhere(
              (element) => element.index == id,
        );

        if (index == -1) {
          throw StateError("Row not found");
        }

        hiveTable.rows.removeAt(index);
        await hiveTable.saveToHive();
        return const Right(true);

      case OSyncTableType.uploadTable:
        final hiveTable = HiveBoxes.uploadTable.get(table.id);
        if (hiveTable == null) {
          throw StateError("Table not found");
        }

        final index = hiveTable.rows.indexWhere(
              (element) => element.id == id,
        );

        if (index == -1) {
          throw StateError("Row not found");
        }

        hiveTable.rows.removeAt(index);
        await hiveTable.saveToHive();
        return const Right(true);

      case OSyncTableType.fileTable:
        final hiveData = HiveBoxes.fileTable.get(id);
        if (hiveData == null) {
          throw StateError("Row not found");
        }

        await hiveData.delete();
        return const Right(true);

      case OSyncTableType.none:
      // No-op: this table type does not store rows.
        return const Right(true);
    }
  } catch (e) {
    return Left(e);
  }
}
