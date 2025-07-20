import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:o_sync/src/core/extensions/extensions.dart';

class Logger {
  const Logger._();

  static void info(String message, {String name = "O_SYNC"}) => dev.log(
    "[${TimeOfDay.now().toString()}] -> $message",
    name: name,
    time: DateTime.now(),
    level: 800,
  );

  static void warning(String message, {String name = "O_SYNC"}) => dev.log(
    "[${TimeOfDay.now().toTimeString12}] -> $message",
    name: name,
    time: DateTime.now(),
    level: 900,
  );

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = "O_SYNC",
  }) => dev.log(
    "[${TimeOfDay.now().toTimeString12}] -> $message",
    name: name,
    time: DateTime.now(),
    level: 1000,
    stackTrace: stackTrace,
    error: error,
  );

  static void plain(String message, [bool allCap = true]) => dev.log(
    allCap ? message.toUpperCase() : message,
    name: "O_SYNC",
    time: DateTime.now(),
  );
}
