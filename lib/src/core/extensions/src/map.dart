part of '../extensions.dart';

/// Extension on [Map] providing utility methods for formatting and debugging.
extension OSMapExt on Map {
  /// Returns a pretty-printed JSON string representation of the map.
  ///
  /// If the map is empty, returns `"{}"`.
  /// In case of an error during encoding, logs the error and returns `"{}"`.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Alice', 'age': 25};
  /// print(map.toBeautifiedString);
  /// ```
  /// Output:
  /// ```json
  /// {
  ///     "name": "Alice",
  ///     "age": 25
  /// }
  /// ```
  String get toBeautifiedString {
    if (isEmpty) return "{}";

    try {
      const JsonEncoder encoder = JsonEncoder.withIndent('    ');
      return encoder.convert(this);
    } catch (e) {
      Logger.error("$e");
      return "{}";
    }
  }
}
