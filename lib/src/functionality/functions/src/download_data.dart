part of '../functions.dart';

Future<Either<dynamic, bool>> osDownloadData(DownloadParams params) async {
  try {
    final startTime = DateTime.now();

    final basicInfos = HiveBoxes.basicInfo.values;

    if (basicInfos.isEmpty) throw Exception("Offline Sync Not Initialized");

    final basicInfo = basicInfos.first;

    Logger.plain("Download Started: ${startTime.toTimeString12}");

    for (final table in params.tables) {
      Logger.plain("Start Fetching for ${table.label}");

      final response = await oSNetworkRequest(
        "${basicInfo.baseUrl}/${table.apiEndPoint}",
        table.apiMethode.value,
        header: params.headers,
        body: params.body,
        showRequestData: true,
      );

      final apiResponse = NetworkResponse.fromRawJson(response);

      if (!apiResponse.success || apiResponse.data is! List) continue;

      final responseData = apiResponse.data as List;
      final tableData = List.generate(
        responseData.length,
        (i) => OSDownloadData(index: i + 1, data: responseData[i]),
      );

      final hiveTable = OSDownloadTable(
        tableKey: table.id,
        tableName: table.label,
        lastUpdated: DateTime.now(),
        rows: tableData,
      );

      await hiveTable.saveToHive;

      Logger.plain("Total Rows for table ${table.label}: ${tableData.length}");
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime);

    Logger.plain("Download Completed At: ${endTime.toTimeString12}");
    Logger.plain("Took $timeTaken to complete Download");

    return const Right(true);
  } catch (e) {
    return Left(e);
  }
}

class DownloadParams {
  final Map<String, String> headers;
  final Map<String, dynamic> body;
  final List<OSyncTable> tables;

  DownloadParams({
    required this.headers,
    required this.body,
    required this.tables,
  });
}
