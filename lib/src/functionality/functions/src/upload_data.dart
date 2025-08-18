// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Uploads un-synced data rows to the API and marks them as uploaded in Hive.
///
/// [headers] - Request headers (e.g. auth, content-type).
/// [rows] - The list of [OSyncNotUploadedData] entries to be uploaded.
///
/// Returns:
/// - [Right(true)] if upload completed successfully.
/// - [Left(error)] if an exception occurs.
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

    for (final entry in rows) {
      final response = await oSNetworkRequest(
        "${basicInfo.baseUrl}/${entry.table.apiEndPoint}",
        entry.table.apiMethode.value,
        header: headers,
        body: entry.data.data,
        showRequestData: true,
      );

      final responseData = NetworkResponse.fromRawJson(response);

      if (responseData.success) {
        final table = uploadTableBox.get(entry.table.id);

        if (table != null) {
          final updatedRows = [
            for (final row in table.rows)
              if (row.id == entry.data.id) row.withSynced else row,
          ];

          final updatedTable = table.withNewData(updatedRows);
          await updatedTable.saveToHive;
        }
      } else {
        throw Exception(responseData.message);
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime);

    Logger.plain("Upload Data Completed At: ${endTime.toTimeString12}");
    Logger.plain("Took $timeTaken to complete Data Upload");

    return const Right(true);
  } catch (e, stackTrace) {
    Logger.error("Upload failed: $e\n$stackTrace");
    return Left(e);
  }
}
