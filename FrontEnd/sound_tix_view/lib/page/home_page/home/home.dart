import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/interested_ticket.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/home_page/home/search_page.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({super.key});

  @override
  State<DefaultHomePage> createState() => _DefaultHomePageState();
}

class _DefaultHomePageState extends State<DefaultHomePage> {
  late Future futureEvents;
  final TextEditingController _searchEventController = TextEditingController();
  int currentIndex = 0;
  int currentPage = 0;
  int currentSize = 5;
  List<Event> events = [];
  var findRequestEvent = {};
  List<InterestedTicket> interestedEvents = [];

  @override
  void initState() {
    super.initState();
    futureEvents = getInitPage();
  }

  getInitPage() async {
    await search();
    await getListInterestedEvents();
    return 0;
  }

  search() {
    var searchRequest = {
      "name": _searchEventController.text,
    };
    findRequestEvent = searchRequest;
    getListEvents(currentPage, currentSize, findRequestEvent);
  }

  getListEvents(page, size, findRequest) async {
    var rawData = await httpPost("http://localhost:8080/event/search?page=$page&size=$size", findRequest);

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
    });
    return 0;
  }

  getListInterestedEvents() async {
    var rawData = await httpPost("http://localhost:8080/interested-event/search", {"userId": 1});

    setState(() {
      interestedEvents = [];

      for (var element in rawData["body"]["content"]) {
        var interestedEvent = InterestedTicket.fromMap(element);
        interestedEvents.add(interestedEvent);
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
            return Scaffold(
              appBar: AppBar(
                title: Image.asset("images/logo_homepage.jpg", width: 120),
                actions: [
                  InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: const Icon(Icons.notifications),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPageWidget(),
                        ),
                      );
                    },
                    child: const Icon(Icons.search),
                  ),
                  const SizedBox(width: 15),
                ],
                bottom: TabBar(
                  indicatorColor: changeThemeModel.isDark ? Colors.white : const Color(0xFF2DC275),
                  labelStyle:
                      TextStyle(color: changeThemeModel.isDark ? Colors.white : const Color(0xFF2DC275), fontSize: 15, fontWeight: FontWeight.w500),
                  tabs: <Widget>[
                    Tab(text: AppLocalizations.of(context).translate("ALL")),
                    Tab(text: AppLocalizations.of(context).translate("INTERESTED")),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          CarouselSlider(
                            items: ["event1.png", "event2.png", "event3.png", "event4.png", "event5.png"].map((imageName) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset("images/$imageName", fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 150,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            margin: const EdgeInsets.only(top: 30, bottom: 5),
                            child: Text(AppLocalizations.of(context).translate("Featured Events"),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                for (Event event in events)
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      context.go(
                                        '/detail-event/${event.eventId}',
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
                                                      Icon(Icons.calendar_month,
                                                          size: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black),
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
                                                          style:
                                                              TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
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
                            ),
                          ),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                currentSize += 5;
                                getListEvents(currentPage, currentSize, findRequestEvent);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF2DC275),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                              child: Text(
                                AppLocalizations.of(context).translate("See more"),
                                style: const TextStyle(color: Color(0xFF2DC275), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: (interestedEvents.isNotEmpty)
                        ? Column(
                            children: [
                              for (InterestedTicket interestedEvent in interestedEvents)
                                InterestedEventWidget(interestedId: interestedEvent.interestedId!),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 160),
                              Image.asset("images/empty-interested.png",
                                  height: 150, width: 150, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                              Text(
                                AppLocalizations.of(context).translate("You are not interested in any tickets!"),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                              ),
                            ],
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

class InterestedEventWidget extends StatefulWidget {
  final int interestedId;
  const InterestedEventWidget({super.key, required this.interestedId});

  @override
  State<InterestedEventWidget> createState() => _InterestedEventWidgetState();
}

class _InterestedEventWidgetState extends State<InterestedEventWidget> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    getEvent(widget.interestedId);
  }

  getEvent(interestedId) async {
    var rawData = await httpPost("http://localhost:8080/event/search", {"interestedId": interestedId});

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (Event event in events)
          InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              context.go('/detail-event/${event.eventId}');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                              const Icon(Icons.calendar_month, size: 16),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat("dd-MM-yyyy").format(event.dateTime),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(width: 35),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 10),
                              Text(event.location, style: const TextStyle(fontSize: 14)),
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
    );
  }
}
