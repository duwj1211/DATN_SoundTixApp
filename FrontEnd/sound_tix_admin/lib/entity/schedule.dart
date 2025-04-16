import 'dart:convert';

class Schedule {
  int? scheduleId;
  DateTime startTime;
  DateTime endTime;

  Schedule({
    this.scheduleId,
    required this.startTime,
    required this.endTime,
  });

  Schedule copyWith({
    int? scheduleId,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Schedule(
      scheduleId: scheduleId ?? this.scheduleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scheduleId': scheduleId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      scheduleId: map['schedule_id'] != null ? map['schedule_id'] as int : null,
      startTime:
          map['start_time'] is int ? DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int) : DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] is int ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int) : DateTime.parse(map['end_time'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromJson(String source) => Schedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Schedule(scheduleId: $scheduleId, startTime: $startTime, endTime: $endTime)';

  @override
  bool operator ==(covariant Schedule other) {
    if (identical(this, other)) return true;

    return other.scheduleId == scheduleId && other.startTime == startTime && other.endTime == endTime;
  }

  @override
  int get hashCode => scheduleId.hashCode ^ startTime.hashCode ^ endTime.hashCode;
}
