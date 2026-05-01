import 'dart:convert';

class ScheduleTime implements Comparable<ScheduleTime> {
  final int hour;
  final int minute;

  const ScheduleTime({required this.hour, required this.minute});

  @override
  int compareTo(ScheduleTime other) {
    if (hour != other.hour) return hour - other.hour;
    return minute - other.minute;
  }
}

List<ScheduleTime> parseScheduleTimes(String scheduleTimesJson) {
  try {
    if (scheduleTimesJson.isEmpty || scheduleTimesJson == '[]') {
      return [];
    }
    final List<dynamic> times = List.from(
      scheduleTimesJson.startsWith('[')
          ? (jsonDecode(scheduleTimesJson) as List)
          : scheduleTimesJson
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList(),
    );
    return times.map((t) {
      final str = t.toString().trim().replaceAll('"', '');
      final parts = str.split(':');
      return ScheduleTime(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }).toList();
  } catch (_) {
    return [];
  }
}
