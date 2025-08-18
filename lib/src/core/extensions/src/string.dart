part of '../extensions.dart';

extension OSStringExtension on String {
  String get snakeCase => replaceAll(" ", "_").toLowerCase();
}