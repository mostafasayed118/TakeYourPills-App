import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String toDisplayDate() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String toDisplayTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String toDisplayDateTime() {
    return '$toDisplayDate $toDisplayTime';
  }

  /// Returns a DateTime with only date components (time set to 00:00:00)
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }
}
