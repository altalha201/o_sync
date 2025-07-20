part of '../functions.dart';

Future<Either<dynamic, bool>> oSClearTables([bool onlyUp = false]) async {
  try {
     var boxes = [
       if (!onlyUp) HiveBoxes.downloadTable,
       HiveBoxes.uploadTable,
       HiveBoxes.fileTable
     ];

     for (var box in boxes) {
       await box.clear();
     }
     return const Right(true);
  } catch (e) {
    return Left(e);
  }
}