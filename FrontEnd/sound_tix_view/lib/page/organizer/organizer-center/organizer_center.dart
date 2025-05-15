import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/organizer/organizer-center/option/organizer_create_event_widget.dart';
import 'package:sound_tix_view/page/organizer/root-organizer/root_organizer_page.dart';

class OrganizerCenterWidget extends StatefulWidget {
  const OrganizerCenterWidget({super.key});

  @override
  State<OrganizerCenterWidget> createState() => _OrganizerCenterWidgetState();
}

class _OrganizerCenterWidgetState extends State<OrganizerCenterWidget> {
  late Future futureEvents;
  final TextEditingController _searchEventController = TextEditingController();
  Timer? _debounceTimer;
  int currentIndex = 0;
  int currentPage = 0;
  int currentSize = 5;
  List<Event> events = [];
  var findRequestEvent = {};
  User? user;

  @override
  void initState() {
    super.initState();
    futureEvents = getInitPage();
  }

  getInitPage() async {
    await getDetailUser();
    await search();
    return 0;
  }

  getDetailUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (mounted) {
      var response = await httpGet(context, "http://localhost:8080/user/$userId");
      setState(() {
        user = User.fromMap(response["body"]);
      });
    }
  }

  search() {
    var searchRequest = {
      "name": _searchEventController.text,
      "organizer": user!.fullName,
    };
    findRequestEvent = searchRequest;
    getListEvents(currentPage, currentSize, findRequestEvent);
  }

  getListEvents(page, size, findRequest) async {
    var rawData = await httpPost(context, "http://localhost:8080/event/search?page=$page&size=$size", findRequest);

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
    });
    return 0;
  }

  @override
  void dispose() {
    _searchEventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return FutureBuilder(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RootOrganizerPage(
              currentPage: "My event",
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: _searchEventController,
                            onChanged: (value) {
                              setState(() {
                                _searchEventController.text;
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
                              hintText: "Search event",
                              hintStyle: const TextStyle(fontSize: 14),
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: _searchEventController.text != ""
                                  ? InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _searchEventController.clear();
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
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEventWidget(
                                onSubmit: () {
                                  getListEvents(currentPage, currentSize, findRequestEvent);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2DC275),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                const Icon(Icons.add, size: 18, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  AppLocalizations.of(context).translate("Create event"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  events.isNotEmpty
                      ? Column(
                          children: [
                            for (Event event in events)
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context.go(
                                    '/organizer/detail-event/${event.eventId}',
                                    extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
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
                                            AppLocalizations.of(context).translate("Only from price").replaceAll("{price}", "500".toString()),
                                            style: const TextStyle(color: Color(0xFF2DC275), fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_month, size: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    DateFormat("dd-MM-yyyy").format(event.dateTime),
                                                    style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 35),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, size: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                                  const SizedBox(width: 10),
                                                  Text(event.location,
                                                      style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
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
                              AppLocalizations.of(context).translate("No events found"),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                ],
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
