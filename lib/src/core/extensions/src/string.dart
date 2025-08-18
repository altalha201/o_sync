// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../extensions.dart';

extension OSStringExtension on String {
  String get snakeCase => replaceAll(" ", "_").toLowerCase();
}