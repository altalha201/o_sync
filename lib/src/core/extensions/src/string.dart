part of '../extensions.dart';

extension StringExtension on String {
  String get snackCase => replaceAll(" ", "_").toLowerCase();
}