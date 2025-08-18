// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:convert';

/// Represents a generic API response for offline sync operations.
class NetworkResponse {
  /// Whether the request was successful.
  bool success = false;

  /// HTTP status code of the response.
  int statusCode = 0;

  /// Human-readable message returned by the API.
  String message = '';

  /// Error message if the request failed.
  String error = '';

  /// Optional table name associated with the response.
  String tableName = '';

  /// Pagination info if the response contains paginated data.
  Pagination? pagination;

  /// The main payload returned by the API.
  dynamic data;

  NetworkResponse();

  /// Creates an instance from a raw JSON string.
  factory NetworkResponse.fromRawJson(String source) =>
      NetworkResponse.fromJson(json.decode(source));

  /// Creates an instance from a JSON map.
  factory NetworkResponse.fromJson(Map<String, dynamic> map) =>
      NetworkResponse()
        ..success = map[_Json.success] ?? (map[_Json.status] == "success") ?? false
        ..tableName = map[_Json.tableName] ?? ''
        ..statusCode = map[_Json.statusCode] ?? 0
        ..message = _formatMessage(map[_Json.message])
        ..error = map[_Json.error] ?? ''
        ..data = map[_Json.data]
        ..pagination =
        map[_Json.pagination] != null ? Pagination.fromJson(map[_Json.pagination]) : null;

  @override
  String toString() =>
      'NetworkResponse(success: $success, message: $message, tableName: $tableName, data: $data'
          '${pagination != null ? ', pagination: $pagination' : ''})';

  /// Helper method to format messages from different structures returned by the API.
  static String _formatMessage(dynamic message) {
    if (message is String) return message;
    if (message is Map<String, dynamic>) {
      return message.values.expand((errors) => errors).join(', ');
    }
    return 'Unknown error occurred';
  }
}

/// Represents pagination information for API responses.
class Pagination {
  /// Current page index.
  int? currentPage;

  /// Number of items per page.
  int? perPage;

  /// Total number of items.
  int? total;

  /// Last page index.
  int? lastPage;

  Pagination();

  /// Creates a [Pagination] instance from a raw JSON string.
  factory Pagination.fromRawJson(String source) =>
      Pagination.fromJson(json.decode(source));

  /// Creates a [Pagination] instance from a JSON map.
  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination()
    ..currentPage = json[_Json.currentPage]
    ..perPage = json[_Json.perPage]
    ..total = json[_Json.total]
    ..lastPage = json[_Json.lastPage];

  @override
  String toString() {
    return 'Pagination(currentPage: $currentPage, perPage: $perPage, total: $total, lastPage: $lastPage)';
  }
}

/// Extension for [NetworkResponse] providing helper methods.
extension ApiResponseExt on NetworkResponse {
  /// Returns a copy of the response with updated fields.
  NetworkResponse copyWith({
    bool? success,
    int? statusCode,
    String? message,
    dynamic data,
  }) {
    return NetworkResponse()
      ..success = success ?? this.success
      ..statusCode = statusCode ?? this.statusCode
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }

  /// Converts the response to a raw JSON string.
  String toRawJson() => json.encode(toJson());

  /// Converts the response to a JSON map.
  Map<String, dynamic> toJson() => {
    _Json.success: success,
    _Json.statusCode: statusCode,
    _Json.message: message,
    _Json.data: data,
  };
}

/// JSON key constants used for [NetworkResponse] and [Pagination] serialization.
class _Json {
  static const String success = 'success';
  static const String statusCode = 'statusCode';
  static const String message = 'message';
  static const String tableName = 'table_name';
  static const String error = 'error';
  static const String data = 'data';
  static const String currentPage = 'current_page';
  static const String perPage = 'per_page';
  static const String total = 'total';
  static const String lastPage = 'last_page';
  static const String pagination = 'pagination';
  static const String status = 'status';
}
