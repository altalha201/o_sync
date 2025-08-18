// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

/// Represents HTTP methods used for offline sync network requests.
enum OSyncNetworkMethod {
  /// GET method for fetching data.
  get,

  /// POST method for creating or sending data.
  post,

  /// PUT method for updating data completely.
  put,

  /// PATCH method for partially updating data.
  patch,

  /// DELETE method for removing data.
  delete,
}

/// Extension providing helper methods for [OSyncNetworkMethod].
extension ApiMethodeExt on OSyncNetworkMethod {
  /// Returns the uppercase string representation of the HTTP method.
  ///
  /// Example:
  /// ```dart
  /// OSyncNetworkMethod.post.value // returns "POST"
  /// ```
  String get value => name.toUpperCase();
}
