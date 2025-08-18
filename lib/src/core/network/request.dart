// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../logger/logger.dart';
import 'enum/api_method.dart';
import 'model/response_model.dart';

/// Sends a generic HTTP request to the given [apiUrl].
///
/// [method] specifies the HTTP method (GET, POST, PUT, DELETE, etc.).
/// [header] optionally provides custom HTTP headers.
/// [body] optionally provides the request payload as a JSON-serializable map.
/// [showRequestData] will log the request body if set to true.
///
/// Returns the response body as a [String].
/// Logs success/failure information using [Logger].
Future<String> oSNetworkRequest(
  String apiUrl,
  String method, {
  Map<String, String>? header,
  Map<String, dynamic>? body,
  bool showRequestData = false,
}) async {
  if (showRequestData && body != null) {
    Logger.plain("REQUEST DATA FOR $apiUrl: $body", false);
  }

  var request = http.Request(method.toUpperCase(), Uri.parse(apiUrl));
  if (body != null) request.body = json.encode(body);
  if (header != null) request.headers.addAll(header);

  final response = await request.send();
  final data = await response.stream.bytesToString();
  final apiResponse = NetworkResponse.fromRawJson(
    data,
  ).copyWith(statusCode: response.statusCode);

  Logger.plain(
    "RESPONSE FOR $apiUrl -> SUCCESS: ${(apiResponse.success).toString().toUpperCase()}",
    false,
  );

  if (!apiResponse.success) {
    Logger.plain(
      "REASON FOR FAILED RESPONSE FOR $apiUrl -> ${apiResponse.toString()}"
      "\nMAIN RESPONSE FOR $apiUrl -> $data",
      false,
    );
  }

  return data;
}

/// Sends a multipart/form-data request to upload a file to [url].
///
/// [header] specifies HTTP headers for authentication or content type.
/// [fieldName] is the form field name for the file.
/// [filePath] is the local path of the file to be uploaded.
///
/// Returns the response body as a [String].
/// Logs the upload result using [Logger].
Future<String> oSNetworkFileRequest({
  required String url,
  required Map<String, String> header,
  required String fieldName,
  required String filePath,
}) async {
  final request = http.MultipartRequest(
    OSyncNetworkMethod.post.value,
    Uri.parse(url),
  );

  request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
  request.headers.addAll(header);

  final response = await request.send();
  final data = await response.stream.bytesToString();
  final apiResponse = NetworkResponse.fromRawJson(data);

  Logger.plain(
    "FILE ${filePath.split("/").last} UPLOADED SUCCESS: ${(apiResponse.success).toString().toUpperCase()}",
    false,
  );

  return data;
}
