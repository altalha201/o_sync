part of '../functions.dart';

Future<Either<dynamic, bool>> osSaveToTable(
  OSyncTable table,
  Map<String, dynamic> data,
) async {
  try {
    switch (table.tableType) {
      case OSyncTableType.downloadTable:
        return _saveToDownloadTable(table, data);
      case OSyncTableType.uploadTable:
        return _saveToUploadTable(table, data);
      default:
        throw Exception('Table not found');
    }
  } catch (e) {
    return Left(e);
  }
}

Future<Either<dynamic, bool>> _saveToDownloadTable(
  OSyncTable table,
  Map<String, dynamic> data,
) async {
  final box =
      HiveBoxes.downloadTable.get(table.id) ??
      OSDownloadTable(
        tableKey: table.id,
        tableName: table.label,
        lastUpdated: DateTime.now(),
        rows: [],
      );

  box.rows.add(OSDownloadData(index: box.rows.length, data: data));
  await box.saveToHive;
  return const Right(true);
}

Future<Either<dynamic, bool>> _saveToUploadTable(
  OSyncTable table,
  Map<String, dynamic> data,
) async {
  final box =
      HiveBoxes.uploadTable.get(table.id) ??
      OSUploadTable(tableKey: table.id, tableName: table.label, rows: []);

  box.rows.add(OSUploadData(id: box.rows.length, data: data));
  await box.saveToHive;
  return const Right(true);
}
