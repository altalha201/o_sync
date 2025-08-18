// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:o_sync/src/core/extensions/extensions.dart';

/// Simple logging utility for the O_SYNC module.
///
/// Provides methods to log messages with different severity levels:
/// [info], [warning], [error], and [plain].
///
/// Uses `dart:developer` under the hood for structured logging.
class Logger {
  const Logger._(); // Private constructor to prevent instantiation.

  /// Logs an informational message.
  ///
  /// [message] is the message to log.
  /// [name] is an optional logger name, defaulting to "O_SYNC".
  static void info(String message, {String name = "O_SYNC"}) => dev.log(
    "[${TimeOfDay.now().toString()}] -> $message",
    name: name,
    time: DateTime.now(),
    level: 800, // Info level
  );

  /// Logs a warning message.
  ///
  /// [message] is the warning message.
  /// [name] is an optional logger name, defaulting to "O_SYNC".
  static void warning(String message, {String name = "O_SYNC"}) => dev.log(
    "[${TimeOfDay.now().toTimeString12}] -> $message",
    name: name,
    time: DateTime.now(),
    level: 900, // Warning level
  );

  /// Logs an error message with optional [error] object and [stackTrace].
  ///
  /// [message] is the error description.
  /// [error] is an optional object representing the error.
  /// [stackTrace] is an optional stack trace.
  /// [name] is an optional logger name, defaulting to "O_SYNC".
  static void error(
      String message, {
        Object? error,
        StackTrace? stackTrace,
        String name = "O_SYNC",
      }) =>
      dev.log(
        "[${TimeOfDay.now().toTimeString12}] -> $message",
        name: name,
        time: DateTime.now(),
        level: 1000, // Error level
        stackTrace: stackTrace,
        error: error,
      );

  /// Logs a plain message without any severity level.
  ///
  /// [message] is the message to log.
  /// [allCap] determines if the message should be converted to uppercase. Defaults to `true`.
  static void plain(String message, [bool allCap = true]) => dev.log(
    allCap ? message.toUpperCase() : message,
    name: "O_SYNC",
    time: DateTime.now(),
  );
}
