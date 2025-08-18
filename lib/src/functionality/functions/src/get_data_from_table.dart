part of '../functions.dart';

/// Retrieves data from a given [OSyncTable] as a list of maps.
/// Returns a [Right] with the data or [Left] with the error.
Future<Either<dynamic, List<Map<String, dynamic>>>> osGetDataFromTable({
  required OSyncTable table,
}) async {
  try {
    switch (table.tableType) {
      case OSyncTableType.uploadTable:
      case OSyncTableType.downloadTable:
        return _getTableData(table);

      case OSyncTableType.fileTable:
        return _getFileTableData();

      case OSyncTableType.none:
        return const Right([]);
    }
  } catch (e, stackTrace) {
    Logger.error(
      "Failed to get data from table ${table.label}: $e\n$stackTrace",
    );
    return Left(e);
  }
}

/// Internal helper to retrieve rows from upload or download tables.
Either<dynamic, List<Map<String, dynamic>>> _getTableData(OSyncTable table) {
  final box =
      table.tableType == OSyncTableType.uploadTable
          ? HiveBoxes.uploadTable
          : HiveBoxes.downloadTable;

  final hiveTable = box.get(table.id);
  if (hiveTable == null) {
    throw Exception("Table not found: ${table.label}");
  }

  List<Map<String, dynamic>> rows;

  if (table.tableType == OSyncTableType.uploadTable) {
    final uploadTable = hiveTable as OSUploadTable;
    rows =
        uploadTable.rows
            .where((row) => row.data != null)
            .map((e) => e.data!)
            .toList();
  } else {
    final downloadTable = hiveTable as OSDownloadTable;
    rows =
        downloadTable.rows
            .where((row) => row.data != null)
            .map((e) => e.data!)
            .toList();
  }

  return Right(rows);
}

/// Internal helper to retrieve data from the file table.
Either<dynamic, List<Map<String, dynamic>>> _getFileTableData() {
  final files = HiveBoxes.fileTable.values.toList().cast<OSFileTable>();
  if (files.isEmpty) return const Right([]);

  final result =
      files
          .map((file) => {"index": file.index, "file_path": file.path})
          .toList();

  return Right(result);
}
