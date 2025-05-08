import 'dart:convert';

class Ticket {
  int? ticketId;
  String name;
  int price;
  int quantityAvailable;
  int sold;
  String detailInformation;
  String qrCode;

  Ticket({
    this.ticketId,
    required this.name,
    required this.price,
    required this.quantityAvailable,
    required this.sold,
    required this.detailInformation,
    required this.qrCode,
  });

  Ticket copyWith({
    int? ticketId,
    String? name,
    int? price,
    int? quantityAvailable,
    int? sold,
    String? detailInformation,
    String? qrCode,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      sold: sold ?? this.sold,
      detailInformation: detailInformation ?? this.detailInformation,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ticketId': ticketId,
      'name': name,
      'price': price,
      'quantityAvailable': quantityAvailable,
      'sold': sold,
      'detailInformation': detailInformation,
      'qrCode': qrCode,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      ticketId: map['ticketId'] != null ? map['ticketId'] as int : null,
      name: map['name'] as String,
      price: map['price'] as int,
      quantityAvailable: map['quantityAvailable'] as int,
      sold: map['sold'] as int,
      detailInformation: map['detailInformation'] as String,
      qrCode: map['qrCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ticket(ticketId: $ticketId, name: $name, price: $price, quantityAvailable: $quantityAvailable, sold: $sold, detailInformation: $detailInformation, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant Ticket other) {
    if (identical(this, other)) return true;

    return other.ticketId == ticketId &&
        other.name == name &&
        other.price == price &&
        other.quantityAvailable == quantityAvailable &&
        other.sold == sold &&
        other.detailInformation == detailInformation &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return ticketId.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantityAvailable.hashCode ^
        sold.hashCode ^
        detailInformation.hashCode ^
        qrCode.hashCode;
  }
}
