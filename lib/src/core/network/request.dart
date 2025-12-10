// Copyright (c) 2025 OSync Authors.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../logger/logger.dart';
import 'enum/api_method.dart';
import 'model/response_model.dart';

/// Sends an HTTP request to the given [apiUrl] using the provided HTTP [method].
///
/// This API supports any HTTP verb (GET, POST, PUT, DELETE, etc.) and handles
/// JSON-encoded payloads for request bodies.
///
/// Parameters:
/// - [apiUrl]: The full endpoint URL.
/// - [method]: The HTTP method as a string (e.g., "GET", "POST").
/// - [header]: Optional headers added to the request.
/// - [body]: Optional request payload, automatically encoded as JSON.
/// - [showRequestData]: If true, logs the JSON payload.
///
/// Returns:
/// - The raw response body as a [String].
///
/// Logging:
/// - Logs request body (optional based on [showRequestData]).
/// - Logs success or failure using [Logger].
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

  final request = http.Request(method.toUpperCase(), Uri.parse(apiUrl));

  if (body != null) {
    request.body = json.encode(body);
  }

  if (header != null) {
    request.headers.addAll(header);
  }

  final response = await request.send();
  final data = await response.stream.bytesToString();

  final apiResponse = NetworkResponse.fromRawJson(
    data,
  ).copyWith(statusCode: response.statusCode);

  Logger.plain(
    "RESPONSE FOR $apiUrl -> SUCCESS: ${apiResponse.success.toString().toUpperCase()}",
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

/// Uploads a file using a multipart/form-data HTTP POST request.
///
/// Parameters:
/// - [url]: The endpoint to upload the file to.
/// - [header]: Headers added to the request (authentication, content-type, etc.).
/// - [fieldName]: The field name assigned to the uploaded file.
/// - [filePath]: Local path to the file being uploaded.
///
/// Returns:
/// - The response body as a [String].
///
/// Logging:
/// - Logs upload success via [Logger].
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
    "FILE ${filePath.split('/').last} UPLOADED SUCCESS: ${apiResponse.success.toString().toUpperCase()}",
    false,
  );

  return data;
}

/// Sends an HTTP request that may contain both JSON fields and file attachments.
///
/// Useful for APIs that accept metadata along with file uploads.
/// Handles multipart file uploads while still allowing additional
/// key–value fields.
///
/// Parameters:
/// - [apiUrl]: The endpoint URL.
/// - [method]: HTTP method (POST, PUT, etc.).
/// - [header]: Optional headers.
/// - [body]: Optional map of standard form fields.
/// - [files]: Optional map where:
///   - key = form field name
///   - value = local file path
/// - [showRequestData]: Logs request body and file list if enabled.
///
/// Returns:
/// - Response body as a [String].
///
/// Logging:
/// - Logs request data (optional).
/// - Logs success/failure using [Logger].
Future<String> oSNetworkRequestWithFile(
  String apiUrl,
  String method, {
  Map<String, String>? header,
  Map<String, dynamic>? body,
  Map<String, String>? files,
  bool showRequestData = false,
}) async {
  if (showRequestData && body != null) {
    Logger.plain("REQUEST DATA FOR $apiUrl: $body", false);
  }

  if (showRequestData && files != null) {
    Logger.plain("FILES FOR $apiUrl: ${files.keys.join(', ')}", false);
  }

  final request = http.MultipartRequest(
    method.toUpperCase(),
    Uri.parse(apiUrl),
  );

  if (header != null) {
    request.headers.addAll(header);
  }

  if (body != null) {
    body.forEach((key, value) {
      request.fields[key] = value;
    });
  }

  if (files != null) {
    for (final entry in files.entries) {
      final file = await http.MultipartFile.fromPath(entry.key, entry.value);
      request.files.add(file);
    }
  }

  final response = await request.send();
  final data = await response.stream.bytesToString();

  final apiResponse = NetworkResponse.fromRawJson(
    data,
  ).copyWith(statusCode: response.statusCode);

  Logger.plain(
    "RESPONSE FOR $apiUrl -> SUCCESS: ${apiResponse.success.toString().toUpperCase()}",
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
