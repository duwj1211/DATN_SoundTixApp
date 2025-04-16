import 'dart:convert';

class Ticket {
  int? ticketId;
  String name;
  int price;
  int quantityAvailable;
  int sold;
  String detailInformation;

  Ticket({
    this.ticketId,
    required this.name,
    required this.price,
    required this.quantityAvailable,
    required this.sold,
    required this.detailInformation,
  });

  Ticket copyWith({
    int? ticketId,
    String? name,
    int? price,
    int? quantityAvailable,
    int? sold,
    String? detailInformation,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      sold: sold ?? this.sold,
      detailInformation: detailInformation ?? this.detailInformation,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ticket(ticketId: $ticketId, name: $name, price: $price, quantityAvailable: $quantityAvailable, sold: $sold, detailInformation: $detailInformation)';
  }

  @override
  bool operator ==(covariant Ticket other) {
    if (identical(this, other)) return true;

    return other.ticketId == ticketId &&
        other.name == name &&
        other.price == price &&
        other.quantityAvailable == quantityAvailable &&
        other.sold == sold &&
        other.detailInformation == detailInformation;
  }

  @override
  int get hashCode {
    return ticketId.hashCode ^ name.hashCode ^ price.hashCode ^ quantityAvailable.hashCode ^ sold.hashCode ^ detailInformation.hashCode;
  }
}
