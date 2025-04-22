// import 'package:flutter/material.dart';
// import 'package:sound_tix_view/api.dart';
// import 'package:sound_tix_view/entity/ticket.dart';

// class ListTicketWidget extends StatefulWidget {
//   final int ticketId;
//   const ListTicketWidget({super.key, required this.ticketId});

//   @override
//   State<ListTicketWidget> createState() => _ListTicketWidgetState();
// }

// class _ListTicketWidgetState extends State<ListTicketWidget> {
//   bool _isLoading = true;
//   List<Ticket> tickets = [];
//   late Future<List<Ticket>> futureTickets;
//   Map<int, int> bookQuantities = {};

//   @override
//   void initState() {
//     super.initState();
//     futureTickets = searchTickets(widget.ticketId);
//   }

//   void searchTicketsAndDisplay(int eventId) async {
//     setState(() {
//       _isLoading = true;
//     });

//     tickets = await searchTickets(eventId);

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _updateTicketQuantity(int index, int newQuantity, int newMoney) {
//     setState(() {
//       bookQuantities[index] = newQuantity;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
