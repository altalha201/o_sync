// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Downloads data from the API for the given [tables] and saves it to Hive.
/// Returns [Right(true)] on success, or [Left(error)] on failure.
///
/// [headers] – HTTP headers to include in the request.
/// [body] – Request body parameters.
/// [tables] – List of [OSyncTable] objects to fetch.
Future<Either<dynamic, bool>> osDownloadData({
  required Map<String, String> headers,
  required Map<String, dynamic> body,
  required List<OSyncTable> tables,
}) async {
  try {
    final startTime = DateTime.now();
    final basicInfos = HiveBoxes.basicInfo.values;

    if (basicInfos.isEmpty) {
      throw Exception("Offline Sync Not Initialized");
    }

    final basicInfo = basicInfos.first;
    Logger.plain("Download Started: ${startTime.toTimeString12}");

    for (final table in tables) {
      Logger.plain("Fetching data for table: ${table.label}");

      final response = await oSNetworkRequest(
        "${basicInfo.baseUrl}/${table.apiEndPoint}",
        table.apiMethode.value,
        header: headers,
        body: body,
        showRequestData: true,
      );

      final apiResponse = NetworkResponse.fromRawJson(response);

      if (!apiResponse.success || apiResponse.data is! List) {
        Logger.warning("No valid data received for table: ${table.label}");
        continue;
      }

      final responseData = apiResponse.data as List;
      final tableData = responseData
          .asMap()
          .entries
          .map((entry) => OSDownloadData(index: entry.key + 1, data: entry.value))
          .toList();

      final hiveTable = OSDownloadTable(
        tableKey: table.id,
        tableName: table.label,
        lastUpdated: DateTime.now(),
        rows: tableData,
      );

      await hiveTable.saveToHive();
      Logger.plain("Total rows for table ${table.label}: ${tableData.length}");
    }

    final endTime = DateTime.now();
    Logger.plain("Download Completed At: ${endTime.toTimeString12}");
    Logger.plain("Total time taken: ${endTime.difference(startTime)}");

    return const Right(true);
  } catch (e, stackTrace) {
    Logger.error("Download failed: $e\n$stackTrace");
    return Left(e);
  }
}
