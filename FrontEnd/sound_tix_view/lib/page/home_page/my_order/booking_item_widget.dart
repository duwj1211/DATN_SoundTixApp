import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/booking.dart';
import 'package:sound_tix_view/entity/ticket.dart';
import 'package:sound_tix_view/page/home_page/my_order/ticket_item_widget.dart';

class BookingItemWidget extends StatefulWidget {
  final Booking booking;
  const BookingItemWidget({super.key, required this.booking});

  @override
  State<BookingItemWidget> createState() => _BookingItemWidgetState();
}

class _BookingItemWidgetState extends State<BookingItemWidget> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    getListTickets();
    widget.booking.totalPrice = 1000;
  }

  getListTickets() async {
    var rawData = await httpPost(context, "http://localhost:8080/ticket/search", {"bookingId": widget.booking.bookingId});

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate("Order #number").replaceAll("{orderNumber}", widget.booking.bookingId.toString()),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: widget.booking.bookingStatus == "Pending"
                            ? Colors.green
                            : widget.booking.bookingStatus == "Paid"
                                ? Colors.purple
                                : widget.booking.bookingStatus == "Canceled"
                                    ? Colors.blue
                                    : Colors.grey)),
                child: Text(widget.booking.bookingStatus,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: widget.booking.bookingStatus == "Pending"
                            ? Colors.green
                            : widget.booking.bookingStatus == "Paid"
                                ? Colors.purple
                                : widget.booking.bookingStatus == "Canceled"
                                    ? Colors.blue
                                    : Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              for (Ticket ticket in tickets) TicketItemWidget(ticket: ticket, quantity: widget.booking.quantity),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('EEE, MM/dd/yyyy h\'h\':mm a').format(widget.booking.createAt),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppLocalizations.of(context)
                    .translate("Total: totalPrice")
                    .replaceAll("{totalPrice}", NumberFormat('#,###', 'vi_VN').format(widget.booking.totalPrice)),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
