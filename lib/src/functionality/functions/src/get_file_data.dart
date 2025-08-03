part of '../functions.dart';

Future<Either<dynamic, OSyncData<OSFileTable>>> osGetFileTable(
  String tableName,
) async {
  try {
    final box = HiveBoxes.fileTable;

    final returnList = OSyncData<OSFileTable>(
      tableName: tableName.snackCase,
      tableData: box.values.toList(),
      tableId: 0,
    );

    return Right(returnList);
  } catch (e) {
    return Left(e);
  }
}
