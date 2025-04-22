import 'dart:convert';

class Event {
  int? eventId;
  String name;
  DateTime dateTime;
  String location;
  String description;
  String path;

  Event({
    this.eventId,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.path,
  });

  Event copyWith({
    int? eventId,
    String? name,
    DateTime? dateTime,
    String? location,
    String? description,
    String? path,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      description: description ?? this.description,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventId': eventId,
      'name': name,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'location': location,
      'description': description,
      'path': path,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['eventId'] != null ? map['eventId'] as int : null,
      name: map['name'] as String,
      dateTime: DateTime.parse(map['dateTime']),
      location: map['location'] as String,
      description: map['description'] as String,
      path: map['path'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(eventId: $eventId, name: $name, dateTime: $dateTime, location: $location, description: $description, path: $path)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.eventId == eventId &&
        other.name == name &&
        other.dateTime == dateTime &&
        other.location == location &&
        other.description == description &&
        other.path == path;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^ name.hashCode ^ dateTime.hashCode ^ location.hashCode ^ description.hashCode ^ path.hashCode;
  }
}
