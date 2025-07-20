part of '../extensions.dart';

extension OSDateTimeExt on DateTime {
  String get toDateString =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get toTimeString12 => TimeOfDay.fromDateTime(this).toTimeString12;

  String get toDateTimeString => '$toDateString $toTimeString12';
}

extension OSTimeOfDateExt on TimeOfDay {
  String get toTimeString =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get toTimeString12 =>
      '${hourOfPeriod.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${period.name}';
}
