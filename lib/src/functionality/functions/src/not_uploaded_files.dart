// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Retrieves all files from [HiveBoxes.fileTable] that have not been uploaded yet.
///
/// Returns a [Right] containing a list of [OSFileTable] if successful,
/// or a [Left] with an error message on failure.
Future<Either<dynamic, List<OSFileTable>>> osNotUploadedFiles() async {
  try {
    final notUploadedFiles = HiveBoxes.fileTable.values
        .where((file) => !file.uploaded)
        .toList();

    if (notUploadedFiles.isNotEmpty) {
      Logger.plain("There are ${notUploadedFiles.length} files pending upload");
    } else {
      Logger.plain("No pending files to upload");
    }

    return Right(notUploadedFiles);
  } catch (e, stackTrace) {
    Logger.error("Failed to fetch not-uploaded files: $e\n$stackTrace");
    return Left(e);
  }
}
