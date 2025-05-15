import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/overview_chart.dart';
import 'package:sound_tix_admin/components/ticket_percentage_widget.dart';
import 'package:sound_tix_admin/components/weather_service.dart';
import 'package:sound_tix_admin/entity/artist.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/ticket.dart';
import 'package:sound_tix_admin/entity/user.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  User? user;
  int userId = 1;
  bool _isLoadingUser = true;
  List<User> users = [];
  bool _isLoadingUsers = true;
  int totalItems = 0;
  int activeCount = 0;
  List<Event> events = [];
  bool _isLoadingEvents = true;
  double activePercentage = 0;
  List<User> newUsersCurrentMonth = [];
  bool _isLoadingNewUsersCurrentMonth = true;
  double newUserCurrentMonthPercentage = 0;
  List<User> newUsersPreviousMonth = [];
  bool _isLoadingNewUsersPreviousMonth = true;
  double newUserPreviousMonthPercentage = 0;
  List<Ticket> tickets = [];
  bool _isLoadingTickets = true;
  List<Artist> artists = [];
  bool _isLoadingArtists = true;
  @override
  void initState() {
    getDetailUser(userId);
    getListUsers();
    getListEvents();
    getListTickets();
    getListArtists();
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet(context, "http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
      _isLoadingUser = false;
    });
  }

  getListUsers() async {
    var rawData = await httpPost(context, "http://localhost:8080/user/search", {});

    setState(() {
      users = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        users.add(user);
      }

      totalItems = rawData["body"]["totalItems"];
      activeCount = rawData["body"]["activeCount"];
      activePercentage = (activeCount / totalItems) * 100;

      searchNewUsersCurrentMonth();

      _isLoadingUsers = false;
    });
    return 0;
  }

  getListEvents() async {
    var rawData = await httpPost(context, "http://localhost:8080/event/search", {"sortByDateTimeAsc": true});

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
      _isLoadingEvents = false;
    });
    return 0;
  }

  void searchNewUsersCurrentMonth() async {
    setState(() {
      _isLoadingNewUsersCurrentMonth = true;
    });

    var rawData = await httpPost(context, "http://localhost:8080/user/search", {"filterByCurrentMonth": true});

    setState(() {
      newUsersCurrentMonth = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        newUsersCurrentMonth.add(user);
      }

      newUserCurrentMonthPercentage = (newUsersCurrentMonth.length / totalItems) * 100;
      searchNewUsersPreviousMonth();
      _isLoadingNewUsersCurrentMonth = false;
    });
  }

  void searchNewUsersPreviousMonth() async {
    setState(() {
      _isLoadingNewUsersPreviousMonth = true;
    });

    var rawData = await httpPost(context, "http://localhost:8080/user/search", {"filterByPreviousMonth": true});

    setState(() {
      newUsersPreviousMonth = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        newUsersPreviousMonth.add(user);
      }

      newUserPreviousMonthPercentage = ((newUsersCurrentMonth.length - newUsersPreviousMonth.length) / newUsersPreviousMonth.length) * 100;
      _isLoadingNewUsersPreviousMonth = false;
    });
  }

  getListTickets() async {
    var rawData = await httpPost(context, "http://localhost:8080/ticket/search", {});

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
      _isLoadingTickets = false;
    });
    return 0;
  }

  getListArtists() async {
    var rawData =
        await httpPost(context, "http://localhost:8080/artist/search?page=0&size=5", {});

    setState(() {
      artists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }

      _isLoadingArtists = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Dashboard", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text("A comprehensive overview of your platform.", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _isLoadingUser
                      ? const CircularProgressIndicator()
                      : Row(
                          children: [
                            ClipOval(
                              child: Image.asset("images/${user!.avatar}", height: 48, width: 48),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.back_hand, color: Color.fromARGB(255, 238, 219, 56), size: 20),
                                    const SizedBox(width: 10),
                                    Text(user!.fullName, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                                    children: [
                                      const TextSpan(text: "There are "),
                                      TextSpan(
                                          text: "${events.length} events ", style: TextStyle(color: Colors.pink[300], fontWeight: FontWeight.bold)),
                                      const TextSpan(text: " upcoming."),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                  const WeatherWidget(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("All users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                          const SizedBox(height: 10),
                          _isLoadingUsers
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("$totalItems", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                    _isLoadingNewUsersCurrentMonth
                                        ? const CircularProgressIndicator()
                                        : Row(
                                            children: [
                                              const Icon(Icons.trending_up, color: Colors.green, size: 25),
                                              const SizedBox(width: 5),
                                              Text("${newUserCurrentMonthPercentage.toStringAsFixed(2)} %",
                                                  style: const TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w500)),
                                            ],
                                          )
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Active users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                          const SizedBox(height: 10),
                          _isLoadingUsers
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("$activeCount", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                    Text("${activePercentage.toStringAsFixed(2)} %",
                                        style: const TextStyle(fontSize: 15, color: Colors.deepPurple, fontWeight: FontWeight.w500))
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("New users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                          const SizedBox(height: 10),
                          _isLoadingNewUsersCurrentMonth
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${newUsersCurrentMonth.length}", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                    _isLoadingNewUsersPreviousMonth
                                        ? const CircularProgressIndicator()
                                        : (newUserPreviousMonthPercentage > 0)
                                            ? Row(
                                                children: [
                                                  const Icon(Icons.trending_up, color: Colors.green, size: 25),
                                                  const SizedBox(width: 5),
                                                  Text("${newUserPreviousMonthPercentage.toStringAsFixed(2)} %",
                                                      style: const TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w500)),
                                                ],
                                              )
                                            : (newUserPreviousMonthPercentage < 0)
                                                ? Row(
                                                    children: [
                                                      const Icon(Icons.trending_down, color: Colors.redAccent, size: 25),
                                                      const SizedBox(width: 5),
                                                      Text("${(newUserPreviousMonthPercentage * (-1)).toStringAsFixed(2)} %",
                                                          style: const TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.w500)),
                                                    ],
                                                  )
                                                : Container(),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                    const SizedBox(height: 15),
                    const OverViewChartWidget(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Upcoming events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                    const SizedBox(height: 15),
                    _isLoadingEvents
                        ? const CircularProgressIndicator()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var event in events)
                                  Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
                                    width: 280,
                                    height: 220,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                          child: Image.asset("images/${event.path}", height: 120, fit: BoxFit.cover),
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    event.name,
                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.calendar_month, size: 15),
                                                        const SizedBox(width: 10),
                                                        Text(
                                                          DateFormat("dd-MM-yyyy").format(event.dateTime),
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 45),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.location_on, size: 15),
                                                        const SizedBox(width: 10),
                                                        Text(event.location, style: const TextStyle(fontSize: 13)),
                                                      ],
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
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ticket sales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                          const SizedBox(height: 15),
                          _isLoadingTickets
                              ? const CircularProgressIndicator()
                              : Wrap(
                                  runSpacing: 15,
                                  children: [
                                    for (var ticket in tickets) TicketSoldPercentageWidget(ticket: ticket),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Artists", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                          const SizedBox(height: 15),
                          _isLoadingArtists
                              ? const CircularProgressIndicator()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Expanded(flex: 3, child: Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                        Expanded(child: Text("Genre", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                        Expanded(child: Text("Nationality", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      runSpacing: 20,
                                      children: [
                                        for (var artist in artists)
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    ClipOval(child: Image.asset("images/${artist.avatar}", height: 45, width: 45)),
                                                    const SizedBox(width: 10),
                                                    Text(artist.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ),
                                              Expanded(child: Text(artist.genre, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
                                              Expanded(child: Text(artist.nationality, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
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
            ],
          ),
        ),
      ),
    );
  }
}
