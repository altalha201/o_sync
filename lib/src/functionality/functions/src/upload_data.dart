// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Uploads a list of un-synced data rows to the server and updates
/// their sync status in the local Hive storage.
///
/// This function sequentially processes each entry inside [rows], sends
/// the required file/data payload to the corresponding API endpoint, and
/// updates the stored row as “synced” only if the server response indicates success.
///
/// The upload does **not** stop after the first failed request. All entries
/// will be attempted, allowing partial success scenarios.
///
/// Parameters:
/// - [headers]: HTTP request headers (authentication, content type, etc.).
/// - [rows]: A list of [OSyncNotUploadedData] items representing unsynced rows.
///
/// Returns:
/// - `Right(true)`  → All rows uploaded successfully.
/// - `Right(false)` → Upload completed, but **one or more** rows failed.
/// - `Left(error)`  → An unexpected exception occurred before completion.
///
/// All progress and errors are logged using [Logger].
Future<Either<dynamic, bool>> osUploadData({
  required Map<String, String> headers,
  required List<OSyncNotUploadedData> rows,
}) async {
  try {
    final uploadTableBox = HiveBoxes.uploadTable;
    final startTime = DateTime.now();

    final basicInfos = HiveBoxes.basicInfo.values;
    if (basicInfos.isEmpty) {
      throw Exception("Offline Sync Not Initialized");
    }

    final basicInfo = basicInfos.first;
    Logger.plain("Upload Started: ${startTime.toTimeString12}");

    bool hasError = false;

    for (final entry in rows) {
      late final String response;

      if (entry.data.files?.isNotEmpty ?? false) {
        response = await oSNetworkRequestWithFile(
          "${basicInfo.baseUrl}/${entry.table.apiEndPoint}",
          entry.table.apiMethode.value,
          header: headers,
          body: entry.data.data,
          files: entry.data.files,
          showRequestData: true,
        );
      } else {
        response = await oSNetworkRequest(
          "${basicInfo.baseUrl}/${entry.table.apiEndPoint}",
          entry.table.apiMethode.value,
          header: headers,
          body: entry.data.data,
          showRequestData: true,
        );
      }

      final responseData = NetworkResponse.fromRawJson(response);

      if (responseData.success) {
        final table = uploadTableBox.get(entry.table.id);

        if (table != null) {
          final updatedRows = [
            for (final row in table.rows)
              if (row.id == entry.data.id) row.withSynced else row,
          ];

          final updatedTable = table.withNewData(updatedRows);
          await updatedTable.saveToHive();
        }
      } else {
        hasError = true;
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime);

    Logger.plain(
      "Upload Data Completed At: ${endTime.toTimeString12}"
      "${hasError ? " (with errors)" : ""}",
    );
    Logger.plain("Took $timeTaken to complete Data Upload");

    // true  = full success
    // false = partial failure (some uploads failed)
    return Right(!hasError);
  } catch (e, stackTrace) {
    Logger.error("Upload failed: $e\n$stackTrace");
    return Left(e);
  }
}
