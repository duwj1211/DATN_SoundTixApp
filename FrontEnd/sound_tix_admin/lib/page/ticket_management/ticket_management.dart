import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/ticket_item.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/ticket.dart';
import 'package:sound_tix_admin/page/ticket_management/create_ticket.dart';

class TicketManagementWidget extends StatefulWidget {
  const TicketManagementWidget({super.key});

  @override
  State<TicketManagementWidget> createState() => _TicketManagementWidgetState();
}

class _TicketManagementWidgetState extends State<TicketManagementWidget> {
  late Future futureTicket;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController startPriceController = TextEditingController();
  final TextEditingController endPriceController = TextEditingController();
  int currentPage = 0;
  int totalPages = 0;
  List<Ticket> tickets = [];
  var findRequestTicket = {};
  Timer? _debounceTimer;
  bool isShowTicketFilter = false;
  List<Event> events = [];
  bool? sortByQuantityAvailableAsc;
  int? _selectedEventFilter;
  int? startPrice;
  int? endPrice;

  @override
  void initState() {
    super.initState();
    futureTicket = getInitPage();
  }

  getInitPage() async {
    await search();
    await getListEvents();
    return 0;
  }

  search() {
    var searchRequest = {
      "name": searchController.text,
      "sortByQuantityAvailableAsc": sortByQuantityAvailableAsc,
      "startPrice": startPrice,
      "endPrice": endPrice,
      if (_selectedEventFilter != null)
        "event": {
          "eventId": _selectedEventFilter,
        },
    };
    findRequestTicket = searchRequest;
    getListTickets(currentPage, findRequestTicket);
  }

  getListTickets(page, findRequest) async {
    var rawData = await httpPost("http://localhost:8080/ticket/search?page=$page&size=10", findRequest);

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
    });
    return 0;
  }

  getListEvents() async {
    var rawData = await httpPost("http://localhost:8080/event/search", {});

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
    });
    return 0;
  }

  deleteTicket(ticketId) async {
    var response = await httpDelete("http://localhost:8080/ticket/delete/$ticketId");
    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa vé thành công!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa vé thất bại!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listQuantityAvailableFilter = [
      {"name": "Least available quantity", "value": false},
      {"name": "Most available quantity", "value": true},
    ];
    return FutureBuilder(
      future: futureTicket,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ticket management", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Track, sell, and organize tickets.", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const Text(
                          "All tickets",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 36,
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      searchController.text;
                                    });
                                    if (_debounceTimer?.isActive ?? false) {
                                      _debounceTimer?.cancel();
                                    }

                                    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                                      search();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5),
                                    hintText: "Search",
                                    hintStyle: const TextStyle(fontSize: 14),
                                    prefixIcon: const Icon(Icons.search, size: 20),
                                    suffixIcon: searchController.text != ""
                                        ? InkWell(
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                searchController.clear();
                                                search();
                                              });
                                            },
                                            child: const Icon(Icons.clear, size: 15))
                                        : null,
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    if (isShowTicketFilter) {
                                      isShowTicketFilter = false;
                                      searchController.clear();
                                      startPriceController.clear();
                                      endPriceController.clear();
                                      sortByQuantityAvailableAsc = null;
                                      _selectedEventFilter = null;
                                      startPrice = null;
                                      endPrice = null;
                                    } else {
                                      isShowTicketFilter = true;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.filter_list, size: 18),
                                      const SizedBox(width: 8),
                                      Text(isShowTicketFilter ? "Hide Filters" : "Filters",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CreateTicketWidget();
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                  decoration: BoxDecoration(
                                      color: Colors.blue, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add, size: 20, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text("Create ticket", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isShowTicketFilter)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text("Filter", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Choose from options below and we will filter items for you", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Quantity Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: listQuantityAvailableFilter.map((option) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: sortByQuantityAvailableAsc == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 7),
                                          child: Row(
                                            children: [
                                              Radio<bool>(
                                                activeColor: Colors.blue,
                                                value: option["value"],
                                                groupValue: sortByQuantityAvailableAsc,
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    sortByQuantityAvailableAsc = newValue!;
                                                  });
                                                },
                                              ),
                                              Text(option["name"],
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: sortByQuantityAvailableAsc == option["value"] ? Colors.blue : Colors.black,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Ticket", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: tickets.map((ticket) => ticket.name).toList().map((option) {
                                        return Container(
                                          padding: const EdgeInsets.fromLTRB(3, 0, 10, 0),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: searchController.text == option ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                activeColor: Colors.blue,
                                                value: option,
                                                groupValue: searchController.text,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    searchController.text = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 3),
                                              Text(option,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: searchController.text == option ? Colors.blue : Colors.black,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: [
                                        const Text("From", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 120,
                                          height: 35,
                                          child: TextField(
                                            controller: startPriceController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                startPrice = int.tryParse(value);
                                              });
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(5),
                                              hintText: "From...",
                                              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                              suffixIcon: startPriceController.text.isNotEmpty
                                                  ? InkWell(
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          startPriceController.clear();
                                                          startPrice = null;
                                                        });
                                                      },
                                                      child: const Icon(Icons.clear, size: 15),
                                                    )
                                                  : null,
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("To", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 120,
                                          height: 35,
                                          child: TextField(
                                            controller: endPriceController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                endPrice = int.tryParse(value);
                                              });
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(5),
                                              hintText: "To...",
                                              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                              suffixIcon: endPriceController.text.isNotEmpty
                                                  ? InkWell(
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          endPriceController.clear();
                                                          endPrice = null;
                                                        });
                                                      },
                                                      child: const Icon(Icons.clear, size: 15),
                                                    )
                                                  : null,
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Event", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: [
                                        for (var event in events)
                                          Container(
                                            decoration: BoxDecoration(
                                              border: _selectedEventFilter == event.eventId ? Border.all(color: Colors.blue, width: 5) : null,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            margin: const EdgeInsets.only(right: 20),
                                            child: Tooltip(
                                              message: event.name,
                                              child: InkWell(
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    _selectedEventFilter = event.eventId;
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 70,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: Image.asset("images/${event.path}", fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
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
                                        setState(() {
                                          searchController.clear();
                                          startPriceController.clear();
                                          endPriceController.clear();
                                          sortByQuantityAvailableAsc = null;
                                          _selectedEventFilter = null;
                                          startPrice = null;
                                          endPrice = null;
                                          search();
                                        });
                                      },
                                      child: Container(
                                        width: 90,
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                        child: const Center(
                                            child: Text("Reset", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue))),
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          search();
                                        });
                                      },
                                      child: Container(
                                        width: 90,
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                            color: Colors.blue, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                        child: const Center(
                                            child: Text("Apply", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        for (var ticket in tickets)
                          TicketItemWidget(
                            ticket: ticket,
                            onDelete: () {
                              deleteTicket(ticket.ticketId);
                            },
                          ),
                        // const SizedBox(height: 20),
                        // PaginationWidget(
                        //     totalPages: (ticketsSearched.isNotEmpty) ? (ticketsSearched.length / 10).ceil() : totalPages,
                        //     onPageChanged: (newCurrentPage) {
                        //       setState(() {
                        //         getListTicket(newCurrentPage);
                        //       });
                        //     }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
