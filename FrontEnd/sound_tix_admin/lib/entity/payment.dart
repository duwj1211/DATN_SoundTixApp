import 'dart:convert';

class Payment {
  int? paymentId;
  String paymentMethod;
  String paymentStatus;
  DateTime paymentTime;
  DateTime updatedPaymentTime;
  Payment({
    this.paymentId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentTime,
    required this.updatedPaymentTime,
  });

  Payment copyWith({
    int? paymentId,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? paymentTime,
    DateTime? updatedPaymentTime,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentTime: paymentTime ?? this.paymentTime,
      updatedPaymentTime: updatedPaymentTime ?? this.updatedPaymentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentTime': paymentTime,
      'updatedPaymentTime': updatedPaymentTime,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'] != null ? map['paymentId'] as int : null,
      paymentMethod: map['paymentMethod'] as String,
      paymentStatus: map['paymentStatus'] as String,
      paymentTime: DateTime.parse(map['paymentTime']),
      updatedPaymentTime: DateTime.parse(map['updatedPaymentTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) => Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Payment(paymentId: $paymentId, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, paymentTime: $paymentTime, updatedPaymentTime: $updatedPaymentTime)';
  }

  @override
  bool operator ==(covariant Payment other) {
    if (identical(this, other)) return true;

    return other.paymentId == paymentId &&
        other.paymentMethod == paymentMethod &&
        other.paymentStatus == paymentStatus &&
        other.paymentTime == paymentTime &&
        other.updatedPaymentTime == updatedPaymentTime;
  }

  @override
  int get hashCode {
    return paymentId.hashCode ^ paymentMethod.hashCode ^ paymentStatus.hashCode ^ paymentTime.hashCode ^ updatedPaymentTime.hashCode;
  }
}
