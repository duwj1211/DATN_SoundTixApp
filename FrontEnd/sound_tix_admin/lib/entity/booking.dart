import 'dart:convert';

class Booking {
  int? bookingId;
  int quantity;
  int totalPrice;
  String bookingStatus;
  DateTime createAt;
  Booking({
    this.bookingId,
    required this.quantity,
    required this.totalPrice,
    required this.bookingStatus,
    required this.createAt,
  });

  Booking copyWith({
    int? bookingId,
    int? quantity,
    int? totalPrice,
    String? bookingStatus,
    DateTime? createAt,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'bookingStatus': bookingStatus,
      'createAt': createAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'] != null ? map['bookingId'] as int : null,
      quantity: map['quantity'] as int,
      totalPrice: map['totalPrice'] as int,
      bookingStatus: map['bookingStatus'] as String,
      createAt: DateTime.parse(map['createAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Booking(bookingId: $bookingId, quantity: $quantity, totalPrice: $totalPrice, bookingStatus: $bookingStatus, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant Booking other) {
    if (identical(this, other)) return true;

    return other.bookingId == bookingId &&
        other.quantity == quantity &&
        other.totalPrice == totalPrice &&
        other.bookingStatus == bookingStatus &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return bookingId.hashCode ^ quantity.hashCode ^ totalPrice.hashCode ^ bookingStatus.hashCode ^ createAt.hashCode;
  }
}
