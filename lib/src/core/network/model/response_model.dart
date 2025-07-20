import 'dart:convert';

class NetworkResponse {
  NetworkResponse();

  bool success = false;

  int statusCode = 0;
  String message = '';
  String error = '';
  String tableName = '';
  Pagination? pagination;
  dynamic data;

  factory NetworkResponse.fromRawJson(String source) =>
      NetworkResponse.fromJson(json.decode(source));

  factory NetworkResponse.fromJson(Map<String, dynamic> map) =>
      NetworkResponse()
        ..success = map[_Json.success] ?? false
        ..tableName = map[_Json.tableName] ?? ''
        ..statusCode = map[_Json.statusCode] ?? 0
        ..message = _formatMessage(map[_Json.message])
        ..error = map[_Json.error] ?? ''
        ..data = map[_Json.data]
        ..pagination =
            map[_Json.pagination] != null
                ? Pagination.fromJson(map[_Json.pagination])
                : null;

  @override
  String toString() =>
      'ApiResponse('
      'success: $success,'
      ' message: $message,'
      ' table_name: $tableName,'
      ' data: $data'
      '${pagination != null ? ', pagination: ${pagination.toString()}' : ''}'
      ')';

  static String _formatMessage(dynamic message) {
    if (message is String) {
      return message;
    } else if (message is Map<String, dynamic>) {
      return message.values.expand((errors) => errors).join(', ');
    }
    return 'Unknown error occurred';
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination();

  factory Pagination.fromRawJson(String source) =>
      Pagination.fromJson(json.decode(source));

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      Pagination()
        ..currentPage = json[_Json.currentPage]
        ..perPage = json[_Json.perPage]
        ..total = json[_Json.total]
        ..lastPage = json[_Json.lastPage];

  @override
  String toString() {
    return "Pagination("
        "current_page: $currentPage, "
        "per_page: $perPage, "
        "total: $total, "
        "last_page: $lastPage"
        ")";
  }
}

extension ApiResponseExt on NetworkResponse {
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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    _Json.success: success,
    _Json.statusCode: statusCode,
    _Json.message: message,
    _Json.data: data,
  };
}

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
}
