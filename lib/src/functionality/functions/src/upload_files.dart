part of '../functions.dart';

Future<Either<dynamic, bool>> osUploadFiles(
  Map<String, String> headers,
  List<OSFileTable> files, [
  String fieldName = 'file',
  bool deleteImage = false,
]) async {
  try {
    final startTime = DateTime.now();

    final basicInfos = HiveBoxes.basicInfo.values;

    if (basicInfos.isEmpty) throw Exception('Offline Sync Not Initialized');

    final baseInfo = basicInfos.first;
    bool doNetworkRequest = baseInfo.fileUploadPath != null;
    final url = "${baseInfo.baseUrl}/${baseInfo.fileUploadPath}";

    Logger.plain("Upload File Started: ${startTime.toTimeString12}");

    for (final file in files) {
      final uploadFile = File(file.path);

      Logger.plain("UPLOADING FILE: ${uploadFile.name}", false);

      late final NetworkResponse responseData;
      if (doNetworkRequest) {
        final response = await oSNetworkFileRequest(
          url: url,
          header: headers,
          filePath: file.path,
          fieldName: fieldName,
        );

        responseData = NetworkResponse.fromRawJson(response);
      } else {
        // Simulate successful upload
        responseData = NetworkResponse().copyWith(success: true);
      }

      if (responseData.success) {
        final updatedImage = file.withSynced;
        await updatedImage.saveToHive;

        // Optional: Uncomment to free up space after upload
        if (deleteImage) {
          await uploadFile.delete();
        }
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime);

    Logger.plain("Upload File Completed At: ${endTime.toTimeString12}");
    Logger.plain("Took $timeTaken to complete File Upload");
    return Right(true);
  } catch (e) {
    return Left(e.toString());
  }
}
