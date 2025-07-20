part of '../functions.dart';

Future<Either<dynamic, List<OSyncData<OSUploadData>>>>
osGetUploadTables() async {
  try {
    final box = HiveBoxes.uploadTable;

    final tables = box.values;

    final List<OSyncData<OSUploadData>> returnList =
        tables
            .map(
              (table) => OSyncData(
                tableName: table.tableName,
                tableData: table.rows,
                tableId: table.tableKey,
              ),
            )
            .toList();

    return Right(returnList);
  } catch (e) {
    return Left(e);
  }
}
