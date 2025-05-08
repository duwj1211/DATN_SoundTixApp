import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/func.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/home_page/home/filter_widget.dart';

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

  @override
  void initState() {
    super.initState();
    futureEvent = getInitPage();
  }

  getInitPage() async {
    await search();
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
                                  Navigator.of(context).push(
                                    newCreateRoute(
                                      FilterWidget(
                                        selectedLocationFilter: _selectedLocationFilter,
                                        selectedEventTypeFilter: _selectedEventTypeFilter,
                                        selectedArtistFilter: _selectedArtistFilter,
                                        callbackFilter: (selectedLocationFilter, selectedEventTypeFilter, selectedArtistFilter) {
                                          setState(() {
                                            _selectedLocationFilter = selectedLocationFilter;
                                            _selectedEventTypeFilter = selectedEventTypeFilter;
                                            _selectedArtistFilter = selectedArtistFilter;
                                          });
                                          search();
                                        },
                                      ),
                                    ),
                                  );
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
                              Text(
                                AppLocalizations.of(context).translate("Suggestions for you"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            events.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
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
}
