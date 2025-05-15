import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/artist_item_widget.dart';
import 'package:sound_tix_admin/components/event_type_item_widget.dart';
import 'package:sound_tix_admin/entity/artist.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/event_type.dart';
import 'package:sound_tix_admin/page/event_management/create_event.dart';
import 'package:sound_tix_admin/page/event_management/edit_event.dart';

class EventManagementWidget extends StatefulWidget {
  const EventManagementWidget({super.key});

  @override
  State<EventManagementWidget> createState() => _EventManagementWidgetState();
}

class _EventManagementWidgetState extends State<EventManagementWidget> {
  late Future futureEvent;
  final TextEditingController searchController = TextEditingController();
  int currentPage = 0;
  int totalPages = 0;
  List<Event> events = [];
  var findRequestEvent = {};
  Timer? _debounceTimer;
  bool isShowEventFilter = false;
  bool? sortByDateTimeAsc;
  String _selectedLocationFilter = '';
  String _selectedEventTypeFilter = '';
  String _selectedArtistFilter = '';
  List<EventType> eventTypes = [];
  List<Artist> artists = [];
  String filterBy = 'Week';

  @override
  void initState() {
    super.initState();
    futureEvent = getInitPage();
  }

  getInitPage() async {
    await search();
    await getListEventTypes();
    await getListArtists();
    return 0;
  }

  search() {
    var searchRequest = {
      "name": searchController.text,
      "sortByDateTimeAsc": sortByDateTimeAsc,
      "location": _selectedLocationFilter,
      "eventType": _selectedEventTypeFilter,
      "artist": _selectedArtistFilter,
    };
    findRequestEvent = searchRequest;
    getListEvent(currentPage, findRequestEvent);
  }

  getListEvent(page, findRequest) async {
    var rawData = await httpPost(context, "http://localhost:8080/event/search?page=$page&size=10", findRequest);

    setState(() {
      events = [];
      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
    });
    return 0;
  }

  getListEventTypes() async {
    var rawData = await httpPost(context, "http://localhost:8080/event-type/search", {});
    setState(() {
      eventTypes = [];
      for (var element in rawData["body"]["content"]) {
        var eventType = EventType.fromMap(element);
        eventTypes.add(eventType);
      }
    });
    return 0;
  }

  getListArtists() async {
    var rawData = await httpPost(context, "http://localhost:8080/artist/search", {});

    setState(() {
      artists = [];
      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
    });
    return 0;
  }

  deleteEvent(eventId) async {
    try {
    await httpDelete(context, "http://localhost:8080/event/delete/$eventId");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa sự kiện thành công'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listDateTimeFilter = [
      {"name": "Sort by lastest date", "value": true},
      {"name": "Sort by oldest date", "value": false},
    ];
    List<String> vietnamProvincesAndCities = [
      'An Giang',
      'Bà Rịa - Vũng Tàu',
      'Bạc Liêu',
      'Bắc Kạn',
      'Bắc Giang',
      'Bắc Ninh',
      'Bến Tre',
      'Bình Dương',
      'Bình Định',
      'Bình Phước',
      'Bình Thuận',
      'Cà Mau',
      'Cao Bằng',
      'Cần Thơ',
      'Đà Nẵng',
      'Đắk Lắk',
      'Đắk Nông',
      'Điện Biên',
      'Đồng Nai',
      'Đồng Tháp',
      'Gia Lai',
      'Hà Giang',
      'Hà Nam',
      'Hà Nội',
      'Hà Tĩnh',
      'Hải Dương',
      'Hải Phòng',
      'Hậu Giang',
      'Hòa Bình',
      'Hưng Yên',
      'Khánh Hòa',
      'Kiên Giang',
      'Kon Tum',
      'Lai Châu',
      'Lạng Sơn',
      'Lào Cai',
      'Lâm Đồng',
      'Long An',
      'Nam Định',
      'Nghệ An',
      'Ninh Bình',
      'Ninh Thuận',
      'Phú Thọ',
      'Phú Yên',
      'Quảng Bình',
      'Quảng Nam',
      'Quảng Ngãi',
      'Quảng Ninh',
      'Quảng Trị',
      'Sóc Trăng',
      'Sơn La',
      'Tây Ninh',
      'Thái Bình',
      'Thái Nguyên',
      'Thanh Hóa',
      'Thừa Thiên Huế',
      'Tiền Giang',
      'TP. Hồ Chí Minh',
      'Trà Vinh',
      'Tuyên Quang',
      'Vĩnh Long',
      'Vĩnh Phúc',
      'Yên Bái'
    ];
    List<String> weeks = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return FutureBuilder(
      future: futureEvent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Event management", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Plan, execute, and track events seamlessly.", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const Text(
                          "All events",
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
                              Container(
                                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Show by: ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    PopupMenuButton(
                                      offset: const Offset(2, 30),
                                      tooltip: '',
                                      splashRadius: 10,
                                      child: Row(
                                        children: [
                                          Text(
                                            filterBy,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          const Icon(Icons.keyboard_arrow_down_outlined, size: 20),
                                        ],
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                filterBy = "Week";
                                              });
                                            },
                                            contentPadding: const EdgeInsets.all(0),
                                            hoverColor: Colors.transparent,
                                            title: const Text("Week"),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                filterBy = "Month";
                                              });
                                            },
                                            contentPadding: const EdgeInsets.all(0),
                                            hoverColor: Colors.transparent,
                                            title: const Text("Month"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                    if (isShowEventFilter) {
                                      isShowEventFilter = false;
                                      sortByDateTimeAsc = null;
                                      _selectedLocationFilter = '';
                                      _selectedEventTypeFilter = '';
                                      _selectedArtistFilter = '';
                                    } else {
                                      isShowEventFilter = true;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.filter_list, size: 18),
                                      const SizedBox(width: 8),
                                      Text(isShowEventFilter ? "Hide Filters" : "Filters",
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
                                        return const CreateEventWidget();
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
                                      Text("Create event", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isShowEventFilter)
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
                                    const Text("Date time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: listDateTimeFilter.map((option) {
                                        return Container(
                                          padding: const EdgeInsets.fromLTRB(3, 0, 10, 0),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: sortByDateTimeAsc == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Radio<bool>(
                                                activeColor: Colors.blue,
                                                value: option["value"],
                                                groupValue: sortByDateTimeAsc,
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    sortByDateTimeAsc = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 3),
                                              Text(option["name"],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: sortByDateTimeAsc == option["value"] ? Colors.blue : Colors.black,
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
                                    const Text("Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: [
                                        PopupMenuButton<String>(
                                          tooltip: "",
                                          onSelected: (String city) {
                                            setState(() {
                                              _selectedLocationFilter = city;
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return vietnamProvincesAndCities.map((String city) {
                                              return PopupMenuItem<String>(
                                                value: city,
                                                child: Text(city),
                                              );
                                            }).toList();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey, width: 0.6), borderRadius: BorderRadius.circular(3)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  _selectedLocationFilter == '' ? "Select city" : _selectedLocationFilter,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.arrow_drop_down, size: 22),
                                              ],
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
                                    const Text("Event type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: [
                                        for (var eventType in eventTypes)
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.black),
                                              borderRadius: BorderRadius.circular(99),
                                            ),
                                            margin: const EdgeInsets.only(right: 10),
                                            child: InkWell(
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  _selectedEventTypeFilter = eventType.type;
                                                });
                                              },
                                              child: Text(
                                                eventType.type,
                                                style: TextStyle(
                                                    fontSize: 14, color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.black),
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
                                    const Text("Artist", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: [
                                        for (var artist in artists)
                                          Container(
                                            decoration: BoxDecoration(
                                              border: _selectedArtistFilter == artist.name ? Border.all(color: Colors.blue, width: 3) : null,
                                              borderRadius: BorderRadius.circular(99),
                                            ),
                                            margin: const EdgeInsets.only(right: 20),
                                            child: Tooltip(
                                              message: artist.name,
                                              child: InkWell(
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    _selectedArtistFilter = artist.name;
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: 38,
                                                  height: 38,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(99),
                                                    child: Image.asset("images/${artist.avatar}", fit: BoxFit.cover),
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
                                          sortByDateTimeAsc = null;
                                          _selectedLocationFilter = '';
                                          _selectedEventTypeFilter = '';
                                          _selectedArtistFilter = '';
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
                    SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            filterBy == "Week"
                                ? Row(
                                    children: weeks
                                        .map((week) => Container(
                                              width: 285,
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey, width: 0.5),
                                              ),
                                              child: Text(
                                                week,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(133, 135, 145, 1),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                : Row(
                                    children: months
                                        .map((month) => Container(
                                              width: 285,
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey, width: 0.5),
                                              ),
                                              child: Text(
                                                month,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(133, 135, 145, 1),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                            filterBy == "Week"
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: weeks.map((week) {
                                      // Lấy các sự kiện thuộc ngày hiện tại
                                      final eventsForWeek = events.where((event) {
                                        // Kiểm tra ngày trong tuần của sự kiện
                                        final eventWeekDay = event.dateTime.weekday; // 1: Monday, 7: Sunday
                                        final currentWeekDay = weeks.indexOf(week) + 1; // Tuần bắt đầu từ 1
                                        return eventWeekDay == currentWeekDay;
                                      }).toList();
                                      return SizedBox(
                                        width: 285,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            children: eventsForWeek
                                                .map(
                                                  (event) => EventItemWidget(
                                                    event: event,
                                                    onDelete: () {
                                                      deleteEvent(event.eventId);
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: months.map((month) {
                                      // Lấy các sự kiện thuộc tháng hiện tại
                                      final eventsForMonth = events.where((event) {
                                        final eventMonth = event.dateTime.month; // Lấy tháng của sự kiện
                                        final currentMonth = months.indexOf(month) + 1; // Tháng tương ứng với cột
                                        return eventMonth == currentMonth;
                                      }).toList();
                                      return SizedBox(
                                        width: 285,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            children: eventsForMonth
                                                .map(
                                                  (event) => EventItemWidget(
                                                    event: event,
                                                    onDelete: () {
                                                      deleteEvent(event.eventId);
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
                      ),
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

class EventItemWidget extends StatefulWidget {
  final Event event;
  final Function onDelete;
  const EventItemWidget({super.key, required this.event, required this.onDelete});

  @override
  State<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        height: 235,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.asset("images/${widget.event.path}", fit: BoxFit.cover),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.event.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              DateFormat("dd-MM-yyyy").format(widget.event.dateTime),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14),
                            const SizedBox(width: 3),
                            Text(widget.event.location, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ArtistItemWidget(eventName: widget.event.name),
                        EventTypeItemWidget(eventId: widget.event.eventId),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  return EditEventWidget(
                                    eventId: widget.event.eventId,
                                    eventName: widget.event.name,
                                  );
                                });
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Edit",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
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
                                                        text: "Are you sure you want to delete event \"",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
                                                    TextSpan(
                                                        text: widget.event.name,
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
                                                      setState(() {
                                                        widget.onDelete();
                                                      });
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
                            width: 50,
                            decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
