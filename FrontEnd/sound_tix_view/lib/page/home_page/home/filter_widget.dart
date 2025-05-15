import 'package:flutter/material.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/artist.dart';
import 'package:sound_tix_view/entity/event_type.dart';

class FilterWidget extends StatefulWidget {
  final String selectedLocationFilter;
  final String selectedEventTypeFilter;
  final String selectedArtistFilter;
  final Function callbackFilter;
  const FilterWidget({
    super.key,
    required this.selectedLocationFilter,
    required this.selectedEventTypeFilter,
    required this.selectedArtistFilter,
    required this.callbackFilter,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String _selectedLocationFilter = '';
  String _selectedEventTypeFilter = '';
  String _selectedArtistFilter = '';
  List<EventType> eventTypes = [];
  List<Artist> artists = [];

  @override
  void initState() {
    super.initState();
    _selectedLocationFilter = widget.selectedLocationFilter;
    _selectedEventTypeFilter = widget.selectedEventTypeFilter;
    _selectedArtistFilter = widget.selectedArtistFilter;
    getListEventTypes();
    getListArtists();
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

  @override
  Widget build(BuildContext context) {
    List listLocations = [
      {"name": AppLocalizations.of(context).translate("Ha Noi"), "value": "Hà Nội"},
      {"name": AppLocalizations.of(context).translate("Da Nang"), "value": "Đà Nẵng"},
      {"name": AppLocalizations.of(context).translate("Da Lat"), "value": "Đà Lạt"},
      {"name": AppLocalizations.of(context).translate("Ho Chi Minh"), "value": "Hồ Chí Minh"},
      {"name": AppLocalizations.of(context).translate("Others"), "value": "Others"},
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate("Filters"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("Location"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("Event type"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var eventType in eventTypes)
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                              decoration: BoxDecoration(
                                border: Border.all(color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.grey),
                                borderRadius: BorderRadius.circular(99),
                              ),
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
                                  style: TextStyle(fontSize: 14, color: _selectedEventTypeFilter == eventType.type ? Colors.blue : Colors.black),
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
                      Text(
                        AppLocalizations.of(context).translate("Artist"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var artist in artists)
                            Container(
                              decoration: BoxDecoration(
                                border: _selectedArtistFilter == artist.name ? Border.all(color: Colors.blue, width: 3) : null,
                                borderRadius: BorderRadius.circular(99),
                              ),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
                          widget.callbackFilter(_selectedLocationFilter, _selectedEventTypeFilter, _selectedArtistFilter);
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                          widget.callbackFilter(_selectedLocationFilter, _selectedEventTypeFilter, _selectedArtistFilter);
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
    );
  }
}
