part of '../functions.dart';

Future<Either<dynamic, List<OSFileTable>>> osNotUploadedFiles() async {
  try {
    // Process files
    final notUploadedFiles =
        HiveBoxes.fileTable.values.where((file) => !file.uploaded).toList();

    if (notUploadedFiles.isNotEmpty) {
      Logger.plain("There are ${notUploadedFiles.length} files to upload");
    }

    return Right(notUploadedFiles);
  } catch (e) {
    return Left(e.toString());
  }
}
