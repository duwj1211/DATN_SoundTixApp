import 'dart:convert';

class InterestedTicket {
  int? interestedId;
  DateTime addedTime;

  InterestedTicket({
    this.interestedId,
    required this.addedTime,
  });

  InterestedTicket copyWith({
    int? interestedId,
    DateTime? addedTime,
  }) {
    return InterestedTicket(
      interestedId: interestedId ?? this.interestedId,
      addedTime: addedTime ?? this.addedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'interestedId': interestedId,
      'addedTime': addedTime.millisecondsSinceEpoch,
    };
  }

  factory InterestedTicket.fromMap(Map<String, dynamic> map) {
    return InterestedTicket(
      interestedId: map['interestedId'] != null ? map['interestedId'] as int : null,
      addedTime: map['addedTime'] is int ? DateTime.fromMillisecondsSinceEpoch(map['addedTime'] as int) : DateTime.parse(map['addedTime'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory InterestedTicket.fromJson(String source) => InterestedTicket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'InterestedTicket(interestedId: $interestedId, addedTime: $addedTime)';

  @override
  bool operator ==(covariant InterestedTicket other) {
    if (identical(this, other)) return true;

    return other.interestedId == interestedId && other.addedTime == addedTime;
  }

  @override
  int get hashCode => interestedId.hashCode ^ addedTime.hashCode;
}
