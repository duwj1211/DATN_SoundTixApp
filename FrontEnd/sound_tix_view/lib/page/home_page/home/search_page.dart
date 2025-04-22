import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/entity/artist.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/event_type.dart';
import 'package:sound_tix_view/model/model.dart';

class SearchPageWidget extends StatefulWidget {
  const SearchPageWidget({super.key});

  @override
  State<SearchPageWidget> createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  final TextEditingController searchController = TextEditingController();
  late Future futureEvent;
  List<Event> events = [];
  var findRequestEvent = {};
  DateTime? dateTimeSelected;
  String _selectedLocationFilter = '';
  String _selectedEventTypeFilter = '';
  String _selectedArtistFilter = '';
  Timer? _debounceTimer;
  List<EventType> eventTypes = [];
  List<Artist> artists = [];

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
      "location": _selectedLocationFilter,
      "eventType": _selectedEventTypeFilter,
      "artist": _selectedArtistFilter,
      if (dateTimeSelected != null) "dateTime": DateFormat('yyyy-MM-dd').format(dateTimeSelected!),
    };
    findRequestEvent = searchRequest;
    getListEvents(findRequestEvent);
  }

  getListEvents(findRequest) async {
    var rawData = await httpPost("http://localhost:8080/event/search?page=0&size=10", findRequest);
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
    var rawData = await httpPost("http://localhost:8080/event-type/search", {});
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
    var rawData = await httpPost("http://localhost:8080/artist/search", {});
    setState(() {
      artists = [];
      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
    });
    return 0;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTimeSelected ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != dateTimeSelected) {
      setState(() {
        dateTimeSelected = picked;
        search();
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return FutureBuilder(
        future: futureEvent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0xFF2DC275),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          children: [
                            const ButtonBack(),
                            const SizedBox(width: 20),
                            Text(AppLocalizations.of(context).translate("Search"),
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 12, 15, 6),
                        child: SizedBox(
                          height: 42,
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
                              hintText: AppLocalizations.of(context).translate("Enter keyword"),
                              prefixIcon: const Icon(Icons.search, size: 22),
                              suffixIcon: searchController.text != ""
                                  ? InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          searchController.clear();
                                        });
                                        search();
                                      },
                                      child: const Icon(Icons.clear, size: 20))
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 6),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => _selectDate(context),
                                child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                      color: dateTimeSelected != null ? const Color(0xFF2DC275) : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          dateTimeSelected != null
                                              ? DateFormat('dd/MM/yyyy').format(dateTimeSelected!)
                                              : AppLocalizations.of(context).translate("All days"),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        (dateTimeSelected != null)
                                            ? InkWell(
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    dateTimeSelected = null;
                                                    search();
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(99),
                                                  ),
                                                  child: const Icon(
                                                    Icons.clear,
                                                    size: 14,
                                                    color: Color(0xFF2DC275),
                                                  ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_down_outlined,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                      ],
                                    )),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showFilter(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                      color: (_selectedLocationFilter != '' || _selectedEventTypeFilter != '' || _selectedArtistFilter != '')
                                          ? const Color(0xFF2DC275)
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.filter_alt_outlined,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppLocalizations.of(context).translate("Filters"),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ),
                              if (_selectedLocationFilter != '')
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2DC275),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            _selectedLocationFilter = '';
                                            search();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(99),
                                          ),
                                          child: const Icon(
                                            Icons.clear,
                                            size: 14,
                                            color: Color(0xFF2DC275),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _selectedLocationFilter,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_selectedEventTypeFilter != '')
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2DC275),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            _selectedEventTypeFilter = '';
                                            search();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(99),
                                          ),
                                          child: const Icon(
                                            Icons.clear,
                                            size: 14,
                                            color: Color(0xFF2DC275),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _selectedEventTypeFilter,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_selectedArtistFilter != '')
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2DC275),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            _selectedArtistFilter = '';
                                            search();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(99),
                                          ),
                                          child: const Icon(
                                            Icons.clear,
                                            size: 14,
                                            color: Color(0xFF2DC275),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _selectedArtistFilter,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!(searchController.text != '' ||
                                _selectedLocationFilter != '' ||
                                _selectedEventTypeFilter != '' ||
                                _selectedArtistFilter != '' ||
                                dateTimeSelected != null))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  AppLocalizations.of(context).translate("Suggestions for you"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            events.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      for (Event event in events)
                                        InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            context.go(
                                              '/detail-event/${event.eventId}',
                                              extra: {
                                                "oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.asset("images/${event.path}", fit: BoxFit.cover),
                                                ),
                                                const SizedBox(height: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      event.name,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                          color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      AppLocalizations.of(context)
                                                          .translate("Only from price")
                                                          .replaceAll("{price}", "500".toString()),
                                                      style: const TextStyle(color: Color(0xFF2DC275), fontSize: 14, fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.calendar_month,
                                                                size: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              DateFormat("dd-MM-yyyy").format(event.dateTime),
                                                              style: TextStyle(
                                                                  fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 35),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.location_on,
                                                                size: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                            const SizedBox(width: 10),
                                                            Text(event.location,
                                                                style: TextStyle(
                                                                    fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        AppLocalizations.of(context).translate("No events found!"),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
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
    });
  }

  showFilter(BuildContext context) {
    List listLocations = [
      {"name": AppLocalizations.of(context).translate("Ha Noi"), "value": "Hà Nội"},
      {"name": AppLocalizations.of(context).translate("Da Nang"), "value": "Đà Nẵng"},
      {"name": AppLocalizations.of(context).translate("Da Lat"), "value": "Đà Lạt"},
      {"name": AppLocalizations.of(context).translate("Ho Chi Minh"), "value": "Hồ Chí Minh"},
      {"name": AppLocalizations.of(context).translate("Others"), "value": "Others"},
    ];
    showModalBottomSheet(
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate("Filters"),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("Location"),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: listLocations.map((option) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    value: option["value"],
                                    groupValue: _selectedLocationFilter,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedLocationFilter = newValue!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Text(option["name"], style: const TextStyle(fontSize: 14)),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("Event type"),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var eventType in eventTypes)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.grey),
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
                                        style:
                                            TextStyle(fontSize: 14, color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.black),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("Artist"),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var artist in artists)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: _selectedArtistFilter == artist.name ? Border.all(color: Colors.blue, width: 3) : null,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    margin: const EdgeInsets.only(right: 10),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _selectedLocationFilter = '';
                                _selectedEventTypeFilter = '';
                                _selectedArtistFilter = '';
                                search();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2DC275)), borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(AppLocalizations.of(context).translate("Reset"),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF2DC275)))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                search();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF2DC275),
                                  border: Border.all(color: const Color(0xFF2DC275)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(AppLocalizations.of(context).translate("Apply"),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
