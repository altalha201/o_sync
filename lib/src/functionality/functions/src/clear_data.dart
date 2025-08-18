part of '../functions.dart';

/// Clears the sync-related Hive tables.
///
/// If [onlyUp] is true, only the upload table is cleared; otherwise,
/// download, upload, and file tables are all cleared.
Future<Either<dynamic, bool>> oSClearTables({bool onlyUp = false}) async {
  try {
    final boxes = [
      if (!onlyUp) HiveBoxes.downloadTable,
      HiveBoxes.uploadTable,
      HiveBoxes.fileTable,
    ];

    for (final box in boxes) {
      await box.clear();
    }

    return const Right(true);
  } catch (e) {
    return Left(e);
  }
}
