import 'dart:convert';

class Ticket {
  int? ticketId;
  String name;
  int price;
  int quantityAvailable;
  String detailInformation;

  Ticket({
    this.ticketId,
    required this.name,
    required this.price,
    required this.quantityAvailable,
    required this.detailInformation,
  });

  Ticket copyWith({
    int? ticketId,
    String? name,
    int? price,
    int? quantityAvailable,
    String? detailInformation,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      detailInformation: detailInformation ?? this.detailInformation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ticketId': ticketId,
      'name': name,
      'price': price,
      'quantityAvailable': quantityAvailable,
      'detailInformation': detailInformation,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      ticketId: map['ticketId'] != null ? map['ticketId'] as int : null,
      name: map['name'] as String,
      price: map['price'] as int,
      quantityAvailable: map['quantityAvailable'] as int,
      detailInformation: map['detailInformation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ticket(ticketId: $ticketId, name: $name, price: $price, quantityAvailable: $quantityAvailable, detailInformation: $detailInformation)';
  }

  @override
  bool operator ==(covariant Ticket other) {
    if (identical(this, other)) return true;

    return other.ticketId == ticketId &&
        other.name == name &&
        other.price == price &&
        other.quantityAvailable == quantityAvailable &&
        other.detailInformation == detailInformation;
  }

  @override
  int get hashCode {
    return ticketId.hashCode ^ name.hashCode ^ price.hashCode ^ quantityAvailable.hashCode ^ detailInformation.hashCode;
  }
}
