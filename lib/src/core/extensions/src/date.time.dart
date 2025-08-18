// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

part of '../extensions.dart';

/// Extension on [DateTime] providing convenient formatting helpers.
extension OSDateTimeExt on DateTime {
  /// Returns the date in `DD/MM/YYYY` format.
  String get toDateString =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  /// Returns the time in 12-hour format with AM/PM.
  String get toTimeString12 => TimeOfDay.fromDateTime(this).toTimeString12;

  /// Returns the date and time combined in `DD/MM/YYYY HH:MM AM/PM` format.
  String get toDateTimeString => '$toDateString $toTimeString12';
}

/// Extension on [TimeOfDay] providing convenient formatting helpers.
extension OSTimeOfDateExt on TimeOfDay {
  /// Returns the time in `HH:MM` 24-hour format.
  String get toTimeString =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Returns the time in 12-hour format with AM/PM, e.g., `02:30 PM`.
  String get toTimeString12 =>
      '${hourOfPeriod.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${period.name}';
}
