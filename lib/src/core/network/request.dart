import 'dart:convert';

import 'package:http/http.dart' as http;

import '../logger/logger.dart';
import 'enum/api_method.dart';
import 'model/response_model.dart';

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

Future<String> oSNetworkFileRequest({
  required String url,
  required Map<String, String> header,
  required String filePath,
}) async {
  final request = http.MultipartRequest(
    OSyncNetworkMethod.post.value,
    Uri.parse(url),
  );
  request.files.add(await http.MultipartFile.fromPath('file', filePath));
  request.headers.addAll(header);

  final response = await request.send();
  final data = await response.stream.bytesToString();
  final apiResponse = NetworkResponse.fromRawJson(data);
  Logger.plain(
    "FILE UPLOADED SUCCESS: ${(apiResponse.success).toString().toUpperCase()}",
    false,
  );
  return data;
}
