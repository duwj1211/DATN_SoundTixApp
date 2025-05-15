import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/model/model.dart';

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

  @override
  void initState() {
    super.initState();
    futureEvents = getListEvents(currentPage, currentSize);
  }

  getListEvents(page, size) async {
    var rawData = await httpPost(context, "http://localhost:8080/event/search?page=$page&size=$size", {});

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
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xFF2DC275),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("images/logo_homepage_no_bg.png", width: 100, color: Colors.white),
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            context.go(
                              '/search-event',
                              extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
                            );
                          },
                          child: const Icon(Icons.search, color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
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
                              child: Text(AppLocalizations.of(context).translate("Featured events"),
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
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
                                                          DateFormat("dd MMM yyyy").format(event.dateTime),
                                                          style:
                                                              TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black),
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
                                  getListEvents(currentPage, currentSize);
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
    var rawData = await httpPost(context, "http://localhost:8080/event/search", {"interestedId": interestedId});

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
