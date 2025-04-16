import 'dart:convert';

class EventType {
  int? eventTypeId;
  String type;

  EventType({
    this.eventTypeId,
    required this.type,
  });

  EventType copyWith({
    int? eventTypeId,
    String? type,
  }) {
    return EventType(
      eventTypeId: eventTypeId ?? this.eventTypeId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventTypeId': eventTypeId,
      'type': type,
    };
  }

  factory EventType.fromMap(Map<String, dynamic> map) {
    return EventType(
      eventTypeId: map['eventTypeId'] != null ? map['eventTypeId'] as int : null,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventType.fromJson(String source) => EventType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EventType(eventTypeId: $eventTypeId, type: $type)';

  @override
  bool operator ==(covariant EventType other) {
    if (identical(this, other)) return true;

    return other.eventTypeId == eventTypeId && other.type == type;
  }

  @override
  int get hashCode => eventTypeId.hashCode ^ type.hashCode;
}
