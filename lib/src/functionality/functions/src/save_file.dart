// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Saves a [File] into the [HiveBoxes.fileTable].
///
/// Each file is stored as an [OSFileTable] entry with an incremental index.
/// Returns:
/// - [Right(true)] if the file was successfully saved.
/// - [Left(error)] if an exception occurs.
Future<Either<dynamic, bool>> oSSaveFile({required File file}) async {
  try {
    final box = HiveBoxes.fileTable;

    // Determine next index (safe for empty or non-sequential keys)
    final nextIndex =
        box.isEmpty
            ? 1
            : (box.keys.cast<int>().fold<int>(0, (p, e) => e > p ? e : p) + 1);

    final fileTable = OSFileTable(index: nextIndex, path: file.path);

    await fileTable.saveToHive();

    Logger.plain("File saved to sync queue: ${file.path} (index $nextIndex)");

    return const Right(true);
  } catch (e, stackTrace) {
    Logger.error("Failed to save file: $e\n$stackTrace");
    return Left(e);
  }
}
