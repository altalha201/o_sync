part of '../extensions.dart';

extension FileExt on File {
  String get name => path.split('/').last;

  String get fileType => path.split('.').last;
}
