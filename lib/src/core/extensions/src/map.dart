part of '../extensions.dart';

extension OSMapExt on Map {
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