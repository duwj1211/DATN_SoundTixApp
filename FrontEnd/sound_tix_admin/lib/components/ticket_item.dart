import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/ticket_event_type_item.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/ticket.dart';
import 'package:sound_tix_admin/page/ticket_management/edit_ticket.dart';

class TicketItemWidget extends StatefulWidget {
  final Ticket ticket;
  final Function? onDelete;
  const TicketItemWidget({super.key, required this.ticket, this.onDelete});

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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500, width: 0.3)),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(height: 200, color: Colors.black, width: 22),
                                  Positioned(
                                    left: -11,
                                    top: 89,
                                    child: Container(
                                        height: 22, width: 22, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 350, height: 200, child: Image.asset("images/${event.path}", fit: BoxFit.cover)),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Expanded(
                                              child: Text("Ticket Number: ${(Random().nextInt(1000000) + 1)}",
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                            ),
                                            const SizedBox(height: 20),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                event.name,
                                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.fromLTRB(45, 5, 45, 5),
                                                    color: const Color.fromARGB(255, 239, 232, 224),
                                                    child: Text(
                                                      DateFormat("dd-MM-yyyy").format(event.dateTime),
                                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 50),
                                                  Tooltip(
                                                    message: widget.ticket.detailInformation,
                                                    child: Container(
                                                      padding: const EdgeInsets.fromLTRB(18, 3, 18, 3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: widget.ticket.name == "Vé Thường"
                                                                  ? Colors.green
                                                                  : widget.ticket.name == "Vé VIP"
                                                                      ? Colors.orange
                                                                      : widget.ticket.name == "Vé VVIP"
                                                                          ? Colors.blue
                                                                          : Colors.purple),
                                                          borderRadius: BorderRadius.circular(5)),
                                                      child: Text(
                                                        widget.ticket.name,
                                                        style: TextStyle(
                                                            fontSize: 14,
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            TicketEventTypeItemWidget(eventId: event.eventId!),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Time:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                    Text(DateFormat("HH:mm").format(event.dateTime),
                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                                const SizedBox(width: 60),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Price:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                    Text("${widget.ticket.price}.000 VNĐ",
                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Address:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                Text(event.location, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: 70,
                                padding: const EdgeInsets.all(5),
                                color: const Color(0xFFF5F0EA),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      padding: const EdgeInsets.all(8),
                                      decoration:
                                          BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(12)),
                                      child: Column(
                                        children: [
                                          const Text("Gate", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                          Text("${(Random().nextInt(10) + 1)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 55,
                                      height: 55,
                                      padding: const EdgeInsets.all(8),
                                      decoration:
                                          BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(12)),
                                      child: Column(
                                        children: [
                                          const Text("Row", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                          Text("${(Random().nextInt(20) + 1)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 55,
                                      height: 55,
                                      padding: const EdgeInsets.all(8),
                                      decoration:
                                          BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(12)),
                                      child: Column(
                                        children: [
                                          const Text("Seat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                          Text("${(Random().nextInt(50) + 1)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditTicketWidget(ticketId: widget.ticket.ticketId!);
                                });
                          },
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Edit",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                        text: "Are you sure you want to delete ticket \"",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
                                                    TextSpan(
                                                        text: widget.ticket.name,
                                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red)),
                                                    const TextSpan(
                                                        text: "\"?",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    hoverColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    splashColor: Colors.transparent,
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      width: 80,
                                                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: const Text("Không",
                                                          style: TextStyle(
                                                              color: Color.fromARGB(255, 37, 138, 221), fontSize: 14, fontWeight: FontWeight.w500)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 30),
                                                  InkWell(
                                                    hoverColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    splashColor: Colors.transparent,
                                                    onTap: () {
                                                      widget.onDelete!();
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      width: 80,
                                                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 37, 138, 221),
                                                        border: Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: const Text("Có",
                                                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          );
  }
}
