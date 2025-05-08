import 'package:flutter/material.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/ticket.dart';

class TicketItemWidget extends StatefulWidget {
  final Ticket ticket;
  final int? quantity;
  final Function? onDelete;
  const TicketItemWidget({super.key, required this.ticket, this.quantity, this.onDelete});

  @override
  State<TicketItemWidget> createState() => _TicketItemWidgetState();
}

class _TicketItemWidgetState extends State<TicketItemWidget> {
  List<Event> events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getListEvents(widget.ticket.name);
  }

  getListEvents(name) async {
    var rawData = await httpPost("http://localhost:8080/event/search", {"ticket": name});

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              for (var event in events)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 72, height: 72, child: Image.asset("images/${event.path}", fit: BoxFit.cover)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: widget.ticket.name == "Vé Thường"
                                              ? Colors.green
                                              : widget.ticket.name == "Vé VIP"
                                                  ? Colors.orange
                                                  : widget.ticket.name == "Vé VVIP"
                                                      ? Colors.blue
                                                      : Colors.purple),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Text(
                                    widget.ticket.name,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: widget.ticket.name == "Vé Thường"
                                            ? Colors.green
                                            : widget.ticket.name == "Vé VIP"
                                                ? Colors.orange
                                                : widget.ticket.name == "Vé VVIP"
                                                    ? Colors.blue
                                                    : Colors.purple,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: (widget.quantity != null) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                                  children: [
                                    if (widget.quantity != null)
                                      Text(
                                        "x${widget.quantity}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    Text(
                                      "${widget.ticket.price}.000 VNĐ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }
}
