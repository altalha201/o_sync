import 'dart:io';

import 'package:dartz/dartz.dart';

import '../core/logger/logger.dart';
import 'functions/functions.dart';
import 'object/exports.dart';
import 'storage/hive_helper.dart';

class OSync {
  const OSync._();

  static Future<void> init(
    String basePackage,
    String baseUrl, [
    String? fileUploadPath,
  ]) async {
    final info = OSBasicInfo(
      packageName: basePackage,
      baseUrl: baseUrl,
      fileUploadPath: fileUploadPath,
    );

    await HiveHelper().init(basePackage);
    await info.saveData;

    Logger.info("Offline Sync Initiated");
  }

  static Future<Either<Exception, bool>> clearSyncTable([
    bool clearAll = true,
  ]) async {
    final response = await oSClearTables(!clearAll);

    return response.fold(
      (e) => Left(Exception(e.toString())),
      (data) => Right(data),
    );
  }

  static Future<Either<Exception, bool>> download({
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required List<OSyncTable> tables,
  }) async {
    final response = await osDownloadData(
      DownloadParams(
        headers: headers,
        body: body,
        tables:
            tables
                .where((e) => e.tableType == OSyncTableType.downloadTable)
                .toList(),
      ),
    );

    return response.fold((e) => Left(e), (b) => Right(b));
  }

  static Future<Either<Exception, int>> notUploadedCount(
    List<OSyncTable> tables,
  ) async {
    try {
      // Run both operations concurrently
      final results = await Future.wait([
        osGetNotUploadedData(tables),
        osNotUploadedFiles(),
      ]);

      // Process results in a single pass
      return Right(
        results.fold<int>(0, (total, either) {
          return either.fold((e) => throw e, (data) => total + data.length);
        }),
      );
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  static Future<Either<Exception, bool>> upload({
    required Map<String, String> headers,
    required List<OSyncTable> tables,
    String fieldName = 'file',
    bool deleteImage = false,
  }) async {
    try {
      // Run both data fetching operations concurrently
      final results = await Future.wait([
        osGetNotUploadedData(tables),
        osNotUploadedFiles(),
      ]);

      // Process results with proper error handling
      final notUploadedData = results[0].fold((e) => throw e, (data) => data);
      final notUploadedFiles = results[1].fold((e) => throw e, (data) => data);

      bool anySuccess = false;

      // Process data upload if exists
      if (notUploadedData.isNotEmpty) {
        final uploadResponse = await osUploadData(
          UploadParams(
            headers: headers,
            rows: notUploadedData as List<OSyncNotUploadedData>,
          ),
        );
        uploadResponse.fold(
          (e) => throw e,
          (success) => anySuccess = anySuccess || success,
        );
      }

      // Process file upload if exists
      if (notUploadedFiles.isNotEmpty) {
        final uploadResponse = await osUploadFiles(
          headers,
          notUploadedFiles as List<OSFileTable>,
          fieldName,
          deleteImage,
        );
        uploadResponse.fold(
          (e) => throw e,
          (success) => anySuccess = anySuccess || success,
        );
      }

      return Right(anySuccess);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  static Future<Either<Exception, bool>> saveToTable({
    required OSyncTable table,
    required Map<String, dynamic> data,
  }) async {
    return await osSaveToTable(table, data).then(
      (v) =>
          v.fold((e) => Left(Exception(e.toString())), (data) => Right(data)),
    );
  }

  static Future<Either<Exception, bool>> saveFile(File file) async {
    return await oSSaveFile(file).then(
      (v) =>
          v.fold((e) => Left(Exception(e.toString())), (data) => Right(data)),
    );
  }

  static Future<Either<Exception, List<OSyncData<OSDownloadData>>>>
  getDownLoadData() async {
    return await osGetDownLoadTables().then(
      (v) =>
          v.fold((e) => Left(Exception(e.toString())), (data) => Right(data)),
    );
  }

  static Future<Either<Exception, List<OSyncData<OSUploadData>>>>
  getUploadData() async {
    return await osGetUploadTables().then(
      (v) =>
          v.fold((e) => Left(Exception(e.toString())), (data) => Right(data)),
    );
  }

  static Future<Either<Exception, List<Map<String, dynamic>>>> getDataFromTable(
    OSyncTable table,
  ) async {
    return await osGetDataFromTable(table).then(
      (res) =>
          res.fold((e) => Left(Exception(e.toString())), (data) => Right(data)),
    );
  }
}
