import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/ticket.dart';

class DetailPage extends StatefulWidget {
  final String? id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Event? event;
  bool _isLoadingData = true;
  List<Ticket> tickets = [];
  bool _isLoading = false;
  int minPrice = 0;
  final Map<int, bool> _isShowMap = {};

  @override
  void initState() {
    int eventId = int.parse(widget.id!);
    getDetailEvent(eventId);
    searchTicketsAndDisplay(eventId);
    super.initState();
  }

  getDetailEvent(eventId) async {
    var rawData = await httpGet(context, "http://localhost:8080/event/$eventId");
    setState(() {
      event = Event.fromMap(rawData["body"]);
      _isLoadingData = false;
    });
  }

  searchTicketsAndDisplay(eventId) async {
    var rawData = await httpPost(context, "http://localhost:8080/ticket/search", {
      "event": {"eventId": eventId}
    });

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
      Ticket minPriceTicket = tickets[0];
      for (Ticket ticket in tickets) {
        if (ticket.price < minPriceTicket.price) {
          minPriceTicket = ticket;
        }
      }
      minPrice = minPriceTicket.price;
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const Scaffold(
            body: Center(
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
            ),
          )
        : Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color(0xFF2DC275),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: [
                      const ButtonBack(),
                      const SizedBox(width: 20),
                      Text(AppLocalizations.of(context).translate("Event details"),
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2D34),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset("images/${event!.path}", fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text(
                                        event!.name,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_month, size: 18, color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text(
                                            DateFormat("dd MMM yyyy").format(event!.dateTime),
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2DC275)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 18, color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text(
                                            event!.location,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2DC275)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Introduce"),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  event!.description,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF2A2D34),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(AppLocalizations.of(context).translate("Ticket information"),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      for (Ticket ticket in tickets)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          _isShowMap[ticket.ticketId!] = !(_isShowMap[ticket.ticketId!] ?? false);
                                                        });
                                                      },
                                                      child: Icon(
                                                          (_isShowMap[ticket.ticketId!] ?? false) ? Icons.expand_more_rounded : Icons.chevron_right,
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(ticket.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                                  ],
                                                ),
                                                Text("${ticket.price}.000 đ",
                                                    style: const TextStyle(color: Color(0xFF2DC275), fontSize: 14, fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                            if (_isShowMap[ticket.ticketId!] ?? false)
                                              Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                      child: Text(
                                                        ticket.detailInformation,
                                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(AppLocalizations.of(context).translate("Organizing Committee"),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Image.asset(
                                  "images/${event!.organizerAvatar}",
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(height: 10),
                                Text(event!.organizer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Text(event!.organizerDescription, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
                color: const Color(0xFF2A2D34),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context).translate("From "), style: const TextStyle(fontSize: 14, color: Colors.white)),
                            TextSpan(text: "$minPrice.000 đ", style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.go(
                            '/book/${event!.eventId}',
                            extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2DC275),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                          child: Text(
                            AppLocalizations.of(context).translate("Buy ticket now"),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
  }
}
