part of '../functions.dart';

Future<Either<dynamic, List<Map<String, dynamic>>>> osGetDataFromTable(
    OSyncTable table,
    ) async {
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
  } catch (e) {
    return Left(e);
  }
}

Either<dynamic, List<Map<String, dynamic>>> _getTableData(OSyncTable table) {
  // Get the appropriate box based on table type
  final box = table.tableType == OSyncTableType.uploadTable
      ? HiveBoxes.uploadTable
      : HiveBoxes.downloadTable;

  // Get the table from Hive
  final hiveTable = box.get(table.id);
  if (hiveTable == null) throw "Table not found";

  // Handle different table types with type-safe access
  if (table.tableType == OSyncTableType.uploadTable) {
    final uploadTable = hiveTable as OSUploadTable;
    final rows = uploadTable.rows
        .where((row) => row.data != null)
        .map((e) => e.data!)
        .toList();
    return Right(rows);
  } else {
    final downloadTable = hiveTable as OSDownloadTable;
    final rows = downloadTable.rows
        .where((row) => row.data != null)
        .map((e) => e.data!)
        .toList();
    return Right(rows);
  }
}

Either<dynamic, List<Map<String, dynamic>>> _getFileTableData() {
  final hiveTable = HiveBoxes.fileTable.values;
  if (hiveTable.isEmpty) return const Right([]);

  final files = hiveTable
      .map((tb) => {"index": tb.index, "file_path": tb.path})
      .toList();

  return Right(files);
}
