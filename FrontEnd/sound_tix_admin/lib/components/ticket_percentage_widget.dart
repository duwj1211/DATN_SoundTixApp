import 'package:flutter/material.dart';
import 'package:sound_tix_admin/entity/ticket.dart';

class TicketSoldPercentageWidget extends StatelessWidget {
  final Ticket ticket;
  const TicketSoldPercentageWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    double percentageSold = ticket.sold / ticket.quantityAvailable;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
              ),
              Text(
                "(${(percentageSold * 100).toStringAsFixed(2)}%)",
                style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percentageSold,
            backgroundColor: Colors.grey[300],
            color: Colors.blue[400],
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          Text(
            "${ticket.price}.000 VNĐ",
            style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
