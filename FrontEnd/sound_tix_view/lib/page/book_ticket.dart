import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/ticket_widget.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/ticket.dart';

class BookPage extends StatefulWidget {
  final String? id;
  const BookPage({super.key, required this.id});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<bool> selectedSeats = List.generate(1000, (index) => false);
  int totalMoney = 0;
  Event? event;
  bool _isLoadingData = true;
  List<Ticket> tickets = [];
  bool _isLoading = true;
  int bookQuantity = 0;
  int selectedTicketId = 0;

  @override
  void initState() {
    int eventId = int.parse(widget.id!);
    getDetailEvent(eventId);
    searchTicketsAndDisplay(eventId);
    super.initState();
  }

  getDetailEvent(eventId) async {
    var rawData = await httpGet("http://localhost:8080/event/$eventId");
    setState(() {
      event = Event.fromMap(rawData["body"]);
      _isLoadingData = false;
    });
  }

  searchTicketsAndDisplay(eventId) async {
    var rawData = await httpPost("http://localhost:8080/ticket/search", {
      "event": {
        "eventId": eventId,
      }
    });

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF2DC275),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      children: [
                        const ButtonBack(),
                        const SizedBox(width: 20),
                        Text(AppLocalizations.of(context).translate("Select ticket"),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).translate("Ticket information"),
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration:
                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event!.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18, color: Color(0xFF2DC275)),
                                  const SizedBox(width: 5),
                                  Text(
                                    event!.location,
                                    style: const TextStyle(color: Color(0xFF2DC275), fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, size: 18, color: Color(0xFF2DC275)),
                                  const SizedBox(width: 5),
                                  Text(DateFormat("dd-MM-yyyy").format(event!.dateTime),
                                      style: const TextStyle(color: Color(0xFF2DC275), fontSize: 16, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(AppLocalizations.of(context).translate("Please select ticket type"),
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 10),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF2A2D34), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black)),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context).translate("Ticket type"),
                                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                                        Text(AppLocalizations.of(context).translate("Quantity"),
                                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    for (Ticket ticket in tickets)
                                      TicketWidget(
                                          ticketId: ticket.ticketId!,
                                          ticketName: ticket.name,
                                          price: ticket.price,
                                          quantityAvailable: ticket.quantityAvailable,
                                          selectedTicketId: selectedTicketId,
                                          callbackSelectedTicketId: (newSelectedTicketId) {
                                            setState(() {
                                              selectedTicketId = newSelectedTicketId;
                                            });
                                          },
                                          callbackQuantityAndMoney: (newQuantity, newMoney) {
                                            setState(() {
                                              bookQuantity = newQuantity;
                                              totalMoney = newMoney;
                                            });
                                          }),
                                  ],
                                ),
                              ),
                        SizedBox(height: (totalMoney != 0) ? 110 : 70),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Container(
                padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
                height: (totalMoney != 0) ? 100 : 60,
                color: const Color(0xFF2A2D34),
                child: Column(
                  children: [
                    if (totalMoney != 0)
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.airplane_ticket_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            const Text("x", style: TextStyle(color: Colors.white, fontSize: 12)),
                            const SizedBox(width: 5),
                            Text("$bookQuantity", style: const TextStyle(color: Colors.white, fontSize: 14))
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                      decoration: BoxDecoration(
                        color: (totalMoney != 0) ? const Color(0xFF2DC275) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            List<int> selectedSeatNumbers = [];
                            for (int i = 0; i < selectedSeats.length; i++) {
                              if (selectedSeats[i]) {
                                selectedSeatNumbers.add(i + 1);
                              }
                            }
                          });
                          (totalMoney != 0)
                              ? context.go(
                                  '/pay/${event!.eventId}',
                                  extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
                                )
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context).translate("Notification")),
                                      content: Text(AppLocalizations.of(context).translate("Please select tickets before payment")),
                                      actions: [
                                        TextButton(
                                          child: Text(AppLocalizations.of(context).translate('OK')),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (totalMoney != 0)
                                  ? AppLocalizations.of(context)
                                      .translate("totalMoneyMessage")
                                      .replaceAll("{totalMoney}", NumberFormat('#,###', 'vi_VN').format(totalMoney))
                                  : AppLocalizations.of(context).translate("noTicketMessage"),
                              style: TextStyle(
                                color: (totalMoney != 0) ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
  }
}
