part of '../functions.dart';

/// Returns all download tables stored in Hive as a list of `OSyncData<OSDownloadData>`.
///
/// Wraps the result in an `Either` to capture potential errors.
Future<Either<dynamic, List<OSyncData<OSDownloadData>>>> osGetDownloadTables() async {
  try {
    // Get the download table box
    final box = HiveBoxes.downloadTable;

    // Read all tables from Hive
    final tables = box.values.toList().cast<OSDownloadTable>();

    // Map Hive tables to generic OSyncData objects
    final List<OSyncData<OSDownloadData>> returnList = tables.map(
          (table) {
        return OSyncData<OSDownloadData>(
          tableName: table.tableName,
          tableData: table.rows,
          tableId: table.tableKey,
        );
      },
    ).toList();

    return Right(returnList);
  } catch (e, stackTrace) {
    Logger.error('Failed to get download tables: $e\n$stackTrace');
    return Left(e);
  }
}
