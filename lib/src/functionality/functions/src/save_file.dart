part of '../functions.dart';

Future<Either<dynamic, bool>> oSSaveFile(File file) async {
  try {
    final box = HiveBoxes.fileTable;
    late final OSFileTable fileTable;
    if (box.isEmpty) {
      fileTable = OSFileTable(index: 1, path: file.path);
    } else {
      final lastIndex = box.keys.last;
      fileTable = OSFileTable(index: lastIndex + 1, path: file.path);
    }
    await fileTable.saveToHive;

    return const Right(true);
  } catch (e) {
    return Left(e);
  }
}