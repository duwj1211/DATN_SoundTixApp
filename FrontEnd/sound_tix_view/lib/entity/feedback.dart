import 'dart:convert';

class SupportAndFeedback {
  int? feedbackId;
  String title;
  String content;
  String type;
  DateTime feedbackTime;
  String status;
  int starCount;
  String? reply;
  DateTime? replyTime;
  SupportAndFeedback({
    this.feedbackId,
    required this.title,
    required this.content,
    required this.type,
    required this.feedbackTime,
    required this.status,
    required this.starCount,
    this.reply,
    this.replyTime,
  });

  SupportAndFeedback copyWith({
    int? feedbackId,
    String? title,
    String? content,
    String? type,
    DateTime? feedbackTime,
    String? status,
    int? starCount,
    String? reply,
    DateTime? replyTime,
  }) {
    return SupportAndFeedback(
      feedbackId: feedbackId ?? this.feedbackId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      feedbackTime: feedbackTime ?? this.feedbackTime,
      status: status ?? this.status,
      starCount: starCount ?? this.starCount,
      reply: reply ?? this.reply,
      replyTime: replyTime ?? this.replyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'feedbackId': feedbackId,
      'title': title,
      'content': content,
      'type': type,
      'feedbackTime': feedbackTime,
      'status': status,
      'starCount': starCount,
      'reply': reply,
      'replyTime': replyTime,
    };
  }

  factory SupportAndFeedback.fromMap(Map<String, dynamic> map) {
    return SupportAndFeedback(
      feedbackId: map['feedbackId'] != null ? map['feedbackId'] as int : null,
      title: map['title'] as String,
      content: map['content'] as String,
      type: map['type'] as String,
      feedbackTime: DateTime.parse(map['feedbackTime']),
      status: map['status'] as String,
      starCount: map['starCount'] as int,
      reply: map['reply'] != null ? map['reply'] as String : null,
      replyTime: map['replyTime'] != null ? DateTime.parse(map['replyTime']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupportAndFeedback.fromJson(String source) => SupportAndFeedback.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupportAndFeedback(feedbackId: $feedbackId, title: $title, content: $content, type: $type, feedbackTime: $feedbackTime, status: $status, starCount: $starCount, reply: $reply, replyTime: $replyTime)';
  }

  @override
  bool operator ==(covariant SupportAndFeedback other) {
    if (identical(this, other)) return true;

    return other.feedbackId == feedbackId &&
        other.title == title &&
        other.content == content &&
        other.type == type &&
        other.feedbackTime == feedbackTime &&
        other.status == status &&
        other.starCount == starCount &&
        other.reply == reply &&
        other.replyTime == replyTime;
  }

  @override
  int get hashCode {
    return feedbackId.hashCode ^
        title.hashCode ^
        content.hashCode ^
        type.hashCode ^
        feedbackTime.hashCode ^
        status.hashCode ^
        starCount.hashCode ^
        reply.hashCode ^
        replyTime.hashCode;
  }
}
