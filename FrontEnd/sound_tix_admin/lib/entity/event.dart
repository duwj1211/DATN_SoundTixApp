import 'dart:convert';

class Event {
  int? eventId;
  String name;
  DateTime dateTime;
  String location;
  String description;
  String path;
  String organizer;
  String organizerDescription;
  String organizerAvatar;

  Event({
    this.eventId,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.path,
    required this.organizer,
    required this.organizerDescription,
    required this.organizerAvatar,
  });

  Event copyWith({
    int? eventId,
    String? name,
    DateTime? dateTime,
    String? location,
    String? description,
    String? path,
    String? organizer,
    String? organizerDescription,
    String? organizerAvatar,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      description: description ?? this.description,
      path: path ?? this.path,
      organizer: organizer ?? this.organizer,
      organizerDescription: organizerDescription ?? this.organizerDescription,
      organizerAvatar: organizerAvatar ?? this.organizerAvatar,
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
      'organizer': organizer,
      'organizerDescription': organizerDescription,
      'organizerAvatar': organizerAvatar,
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
      organizer: map['organizer'] as String,
      organizerDescription: map['organizerDescription'] as String,
      organizerAvatar: map['organizerAvatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(eventId: $eventId, name: $name, dateTime: $dateTime, location: $location, description: $description, path: $path, organizer: $organizer, organizerDescription: $organizerDescription, organizerAvatar: $organizerAvatar)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.eventId == eventId &&
        other.name == name &&
        other.dateTime == dateTime &&
        other.location == location &&
        other.description == description &&
        other.path == path &&
        other.organizer == organizer &&
        other.organizerDescription == organizerDescription &&
        other.organizerAvatar == organizerAvatar;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        name.hashCode ^
        dateTime.hashCode ^
        location.hashCode ^
        description.hashCode ^
        path.hashCode ^
        organizer.hashCode ^
        organizerDescription.hashCode ^
        organizerAvatar.hashCode;
  }
}
