import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/ticket.dart';
import 'package:sound_tix_view/page/organizer/organizer-center/option/organizer_add_ticket_widget.dart';
import 'package:sound_tix_view/page/organizer/organizer-center/option/organizer_edit_event_widget.dart';

class OrganizerDetailEventWidget extends StatefulWidget {
  final String? id;
  const OrganizerDetailEventWidget({super.key, required this.id});

  @override
  State<OrganizerDetailEventWidget> createState() => _OrganizerDetailEventWidgetState();
}

class _OrganizerDetailEventWidgetState extends State<OrganizerDetailEventWidget> {
  Event? event;
  bool _isLoadingData = true;
  List<Ticket> tickets = [];
  bool _isLoading = false;
  int minPrice = 0;
  final Map<int, bool> _isShowMap = {};
  int? eventId;

  @override
  void initState() {
    eventId = int.parse(widget.id!);
    getInitPage();
    super.initState();
  }

  getInitPage() async {
    await getDetailEvent(eventId);
    await searchTicketsAndDisplay(eventId);
    return 0;
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

  deleteTicket(ticketId) async {
    try {
      await httpDelete(context, "http://localhost:8080/ticket/delete/$ticketId");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa vé thành công'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi, vui lòng thử lại'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
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
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
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
                                                                (_isShowMap[ticket.ticketId!] ?? false)
                                                                    ? Icons.expand_more_rounded
                                                                    : Icons.chevron_right,
                                                                color: Colors.white,
                                                                size: 20),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Text(ticket.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                                        ],
                                                      ),
                                                      Text("${ticket.price}.000 đ",
                                                          style:
                                                              const TextStyle(color: Color(0xFF2DC275), fontSize: 14, fontWeight: FontWeight.w500)),
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
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                showConfirmDialog(ticket);
                                              },
                                              child: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                            ),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: SingleChildScrollView(
                                child: OrganizerAddTicketWidget(
                                  eventId: eventId!,
                                  onSubmit: () {
                                    getInitPage();
                                  },
                                ),
                              ),
                            );
                          },
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
                          AppLocalizations.of(context).translate("Add ticket"),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: SingleChildScrollView(
                                child: OrganizerEditEventWidget(
                                  eventId: event!.eventId,
                                  eventName: event!.name,
                                  onSubmit: () {
                                    getInitPage();
                                  },
                                ),
                              ),
                            );
                          },
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
                          AppLocalizations.of(context).translate("Edit event"),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  showConfirmDialog(Ticket selectedTicket) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 20),
                            const SizedBox(width: 5),
                            Text(AppLocalizations.of(context).translate("Delete ticket"),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(AppLocalizations.of(context).translate('Do you want to delete "${selectedTicket.name}?"'),
                          style: const TextStyle(fontSize: 14, color: Colors.black)),
                      const SizedBox(height: 25),
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
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(AppLocalizations.of(context).translate("Cancel"),
                                  style: const TextStyle(color: Color(0xFF2DC275), fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                              await deleteTicket(selectedTicket.ticketId);
                              getInitPage();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DC275),
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child:
                                  Text(AppLocalizations.of(context).translate("Delete"), style: const TextStyle(color: Colors.white, fontSize: 13)),
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
  }
}
