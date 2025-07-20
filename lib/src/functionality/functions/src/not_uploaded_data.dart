part of '../functions.dart';

Future<Either<dynamic, List<OSyncNotUploadedData>>> osGetNotUploadedData(
  List<OSyncTable> tables,
) async {
  try {
    final returnData = <OSyncNotUploadedData>[];
    final uploadTables = tables.where(
      (e) => e.tableType == OSyncTableType.uploadTable,
    );

    // Process upload tables
    for (final table in uploadTables) {
      final tableValues = HiveBoxes.uploadTable.get(table.id);
      final notUploaded =
          tableValues?.rows.where((e) => !e.uploaded).toList() ?? [];

      if (notUploaded.isEmpty) continue;

      Logger.plain("${table.label} has ${notUploaded.length} data to upload");
      returnData.addAll(
        notUploaded.map(
          (data) => OSyncNotUploadedData(table: table, data: data),
        ),
      );
    }

    return Right(returnData);
  } catch (e) {
    return Left(e);
  }
}
