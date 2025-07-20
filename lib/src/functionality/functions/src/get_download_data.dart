part of '../functions.dart';

Future<Either<dynamic, List<OSyncData<OSDownloadData>>>>
osGetDownLoadTables() async {
  try {
    final box = HiveBoxes.downloadTable;

    final tables = box.values;

    final List<OSyncData<OSDownloadData>> returnList =
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
