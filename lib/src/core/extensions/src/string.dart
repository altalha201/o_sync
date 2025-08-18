part of '../extensions.dart';

extension OSStringExtension on String {
  String get snackCase => replaceAll(" ", "_").toLowerCase();
}