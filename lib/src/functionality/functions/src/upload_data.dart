part of '../functions.dart';

Future<Either<dynamic, bool>> osUploadData(UploadParams uploadParams) async {
  try {
    final unUploadedData = uploadParams.rows;

    final uploadTableBox = HiveBoxes.uploadTable;

    final startTime = DateTime.now();

    final basicInfos = HiveBoxes.basicInfo.values;

    if (basicInfos.isEmpty) throw Exception("Offline Sync Not Initialized");

    final basicInfo = basicInfos.first;

    Logger.plain("Upload Started: ${startTime.toTimeString12}");

    for (final entry in unUploadedData) {
      final response = await oSNetworkRequest(
        "${basicInfo.baseUrl}/${entry.table.apiEndPoint}",
        entry.table.apiMethode.value,
        header: uploadParams.headers,
        body: entry.data.data,
        showRequestData: true,
      );

      final responseData = NetworkResponse.fromRawJson(response);

      if (responseData.success) {
        final table = uploadTableBox.get(entry.table.id);
        final updatedLines = [
          for (final line in table?.rows ?? <OSUploadData>[])
            if (line.id == entry.data.id) line.withSynced else line,
        ];

        final updatedTable = table?.withNewData(updatedLines);
        if (updatedTable != null) {
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
    return Right(true);
  } catch (e) {
    return Left(e.toString());
  }
}

class UploadParams {
  final Map<String, String> headers;
  final List<OSyncNotUploadedData> rows;


  UploadParams({required this.headers, required this.rows});
}
