// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../functions.dart';

/// Uploads files stored in [OSFileTable] to the configured API.
///
/// [headers] - Request headers (e.g. authorization, content-type).
/// [files] - The list of [OSFileTable] entries to upload.
/// [fieldName] - The field name used in the multipart request (default: `'file'`).
/// [deleteImage] - If true, deletes the file from local storage after successful upload.
///
/// Returns:
/// - [Right(true)] if all files were uploaded successfully.
/// - [Left(error)] if an exception occurs.
Future<Either<dynamic, bool>> osUploadFiles({
  required Map<String, String> headers,
  required List<OSFileTable> files,
  String fieldName = 'file',
  bool deleteImage = false,
}) async {
  try {
    final startTime = DateTime.now();
    final basicInfos = HiveBoxes.basicInfo.values;

    if (basicInfos.isEmpty) {
      throw Exception('Offline Sync Not Initialized');
    }

    final baseInfo = basicInfos.first;
    final hasUploadPath = baseInfo.fileUploadPath?.isNotEmpty ?? false;

    if (!hasUploadPath) {
      Logger.warning("File upload skipped: No file upload path configured");
      return const Right(true);
    }

    final url = "${baseInfo.baseUrl}/${baseInfo.fileUploadPath}";
    Logger.plain("Upload File Started: ${startTime.toTimeString12}");

    for (final file in files) {
      final uploadFile = File(file.path);

      if (!await uploadFile.exists()) {
        Logger.warning("File not found: ${file.path}");
        continue;
      }

      Logger.plain("Uploading file: ${uploadFile.uri.pathSegments.last}", false);

      final response = await oSNetworkFileRequest(
        url: url,
        header: headers,
        filePath: file.path,
        fieldName: fieldName,
      );

      final responseData = NetworkResponse.fromRawJson(response);

      if (responseData.success) {
        final updatedImage = file.withSynced;
        await updatedImage.saveToHive();

        if (deleteImage) {
          await uploadFile.delete();
          Logger.plain("Deleted file after upload: ${file.path}");
        }
      } else {
        Logger.warning("File upload failed: ${file.path}, message: ${responseData.message}");
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime);

    Logger.plain("Upload File Completed At: ${endTime.toTimeString12}");
    Logger.plain("Took $timeTaken to complete File Upload");

    return const Right(true);
  } catch (e, stackTrace) {
    Logger.error("File upload failed: $e\n$stackTrace");
    return Left(e);
  }
}
