// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:io';

import 'package:dartz/dartz.dart';

import '../core/logger/logger.dart';
import 'functions/functions.dart';
import 'object/exports.dart';
import 'storage/hive_helper.dart';

/// Main class for Offline Sync operations.
///
/// Provides APIs for initializing sync, saving data/files locally,
/// uploading changes, and retrieving stored data.
class OSync {
  const OSync._();

  /// Initializes the OSync package with app info and base API configuration.
  ///
  /// - [basePackage] : Package or app identifier.
  /// - [baseUrl] : The base API URL for syncing.
  /// - [fileUploadPath] : Optional endpoint path for file uploads.
  static Future<void> init({
    required String basePackage,
    required String baseUrl,
    String? fileUploadPath,
  }) async {
    final info = OSBasicInfo(
      packageName: basePackage,
      baseUrl: baseUrl,
      fileUploadPath: fileUploadPath,
    );

    await HiveHelper().init(basePackage);
    await info.saveData;

    Logger.info("Offline Sync Initialized");
  }

  /// Clears stored sync tables.
  ///
  /// - If [clearAll] is true, clears both upload and download tables.
  /// - If false, clears only upload tables.
  static Future<Either<Exception, bool>> clearSyncTable({
    bool clearAll = true,
  }) async {
    final response = await oSClearTables(onlyUp: !clearAll);
    return response.fold(
      (e) => Left(Exception(e.toString())),
      (data) => Right(data),
    );
  }

  /// Downloads fresh data for the specified [tables].
  ///
  /// Only tables with [OSyncTableType.downloadTable] are processed.
  static Future<Either<Exception, bool>> download({
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required List<OSyncTable> tables,
  }) async {
    final response = await osDownloadData(
      headers: headers,
      body: body,
      tables:
          tables
              .where((e) => e.tableType == OSyncTableType.downloadTable)
              .toList(),
    );

    return response.fold((e) => Left(Exception(e.toString())), Right.new);
  }

  /// Returns the total count of not-yet-uploaded data + files.
  static Future<Either<Exception, int>> notUploadedCount(
    List<OSyncTable> tables,
  ) async {
    try {
      final results = await Future.wait([
        osGetNotUploadedData(tables: tables),
        osNotUploadedFiles(),
      ]);

      final total = results.fold<int>(0, (sum, either) {
        return either.fold((e) => throw e, (data) => sum + data.length);
      });

      return Right(total);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  /// Uploads both data rows and files to the server.
  ///
  /// - [headers] : Request headers for upload.
  /// - [tables] : Tables to check for unuploaded rows.
  /// - [fieldName] : Field name for multipart file upload (default: `file`).
  /// - [deleteAfterUpload] : If true, deletes files from storage after upload.
  static Future<Either<Exception, bool>> upload({
    required Map<String, String> headers,
    required List<OSyncTable> tables,
    String fieldName = 'file',
    bool deleteAfterUpload = false,
  }) async {
    try {
      final results = await Future.wait([
        osGetNotUploadedData(tables: tables),
        osNotUploadedFiles(),
      ]);

      final notUploadedData = results[0].fold(
        (e) => throw e,
        (data) => data as List<OSyncNotUploadedData>,
      );
      final notUploadedFiles = results[1].fold(
        (e) => throw e,
        (data) => data as List<OSFileTable>,
      );

      bool anySuccess = false;

      if (notUploadedData.isNotEmpty) {
        final uploadResponse = await osUploadData(
          headers: headers,
          rows: notUploadedData,
        );
        uploadResponse.fold((e) => throw e, (success) => anySuccess |= success);
      }

      if (notUploadedFiles.isNotEmpty) {
        final uploadResponse = await osUploadFiles(
          headers: headers,
          files: notUploadedFiles,
          fieldName: fieldName,
          deleteImage: deleteAfterUpload,
        );
        uploadResponse.fold((e) => throw e, (success) => anySuccess |= success);
      }

      return Right(anySuccess);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  /// Saves a single record to the specified [table].
  static Future<Either<Exception, bool>> saveToTable({
    required OSyncTable table,
    required Map<String, dynamic> data,
    Map<String, File>? files,
  }) => osSaveToTable(
    table: table,
    data: data,
    files: files,
  ).then((v) => v.fold((e) => Left(Exception(e.toString())), Right.new));

  /// Saves a file locally for future syncing.
  static Future<Either<Exception, bool>> saveFile({required File file}) =>
      oSSaveFile(
        file: file,
      ).then((v) => v.fold((e) => Left(Exception(e.toString())), Right.new));

  /// Retrieves all data from download tables.
  static Future<Either<Exception, List<OSyncData<OSDownloadData>>>>
  getDownloadData() => osGetDownloadTables().then(
    (v) => v.fold((e) => Left(Exception(e.toString())), Right.new),
  );

  /// Retrieves all data from upload tables.
  static Future<Either<Exception, List<OSyncData<OSUploadData>>>>
  getUploadData() => osGetUploadTables().then(
    (v) => v.fold((e) => Left(Exception(e.toString())), Right.new),
  );

  /// Retrieves the file table data.
  static Future<Either<Exception, OSyncData<OSFileTable>>> getFileData({
    String tableName = 'file table',
  }) => osGetFileTable(
    tableName: tableName,
  ).then((v) => v.fold((e) => Left(Exception(e.toString())), Right.new));

  /// Retrieves raw data from a specific [table].
  static Future<Either<Exception, List<Map<String, dynamic>>>>
  getDataFromTable({required OSyncTable table}) => osGetDataFromTable(
    table: table,
  ).then((res) => res.fold((e) => Left(Exception(e.toString())), Right.new));

  /// Deletes a row from a table based on its [tableType].
  static Future<Either<Exception, bool>> deleteRowFromTable({
    required OSyncTable table,
    required int id,
  }) => osDeleteRowFromTable(
    table,
    id,
  ).then((res) => res.fold((e) => Left(Exception(e.toString())), Right.new));
}
