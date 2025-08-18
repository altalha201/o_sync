part of '../functions.dart';

/// Retrieves all rows that have not been uploaded yet for the given [tables].
///
/// Only tables of type [OSyncTableType.uploadTable] are considered.
/// Returns [Right] containing a list of [OSyncNotUploadedData] on success,
/// or [Left] with an error on failure.
Future<Either<dynamic, List<OSyncNotUploadedData>>> osGetNotUploadedData({
  required List<OSyncTable> tables,
}) async {
  try {
    final List<OSyncNotUploadedData> returnData = [];

    // Filter only upload tables
    final uploadTables = tables.where(
      (table) => table.tableType == OSyncTableType.uploadTable,
    );

    for (final table in uploadTables) {
      final hiveTable = HiveBoxes.uploadTable.get(table.id);
      if (hiveTable == null) continue;

      final notUploadedRows =
          hiveTable.rows.where((row) => !row.uploaded).toList();

      if (notUploadedRows.isEmpty) continue;

      Logger.plain(
        "${table.label} has ${notUploadedRows.length} rows to upload",
      );

      returnData.addAll(
        notUploadedRows.map(
          (data) => OSyncNotUploadedData(table: table, data: data),
        ),
      );
    }

    return Right(returnData);
  } catch (e, stackTrace) {
    Logger.error("Failed to get not-uploaded data: $e\n$stackTrace");
    return Left(e);
  }
}
