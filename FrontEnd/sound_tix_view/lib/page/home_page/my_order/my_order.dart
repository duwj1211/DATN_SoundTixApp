import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/booking.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/home_page/my_order/booking_item_widget.dart';
import 'package:sound_tix_view/page/home_page/my_order/order_detail_widget.dart';

class MyTicketPage extends StatefulWidget {
  final Function callbackPageIndex;
  const MyTicketPage({super.key, required this.callbackPageIndex});

  @override
  State<MyTicketPage> createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage> {
  late Future futureBookings;
  int currentPageIndex = 0;
  int currentPage = 0;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    futureBookings = getListBookings(currentPage);
  }

  getListBookings(page) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (mounted) {
      var rawData = await httpPost(context, "http://localhost:8080/booking/search?page=$page&size=10", {"userId": userId});

      setState(() {
        bookings = [];

        for (var element in rawData["body"]["content"]) {
          var booking = Booking.fromMap(element);
          bookings.add(booking);
        }
      });
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return FutureBuilder(
        future: futureBookings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: (bookings.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                            child: Text(
                              AppLocalizations.of(context).translate("My ticket"),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          for (var booking in bookings)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 11, 15, 11),
                              child: InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetailWidget(booking: booking),
                                      ),
                                    );
                                  },
                                  child: BookingItemWidget(booking: booking)),
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 180),
                          Image.asset("images/empty-interested.png",
                              height: 160, width: 160, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          Text(
                            AppLocalizations.of(context).translate("You do not have any tickets yet!"),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 30),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                currentPageIndex = 0;
                                widget.callbackPageIndex(currentPageIndex);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DC275),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                AppLocalizations.of(context).translate("Buy tickets now"),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    });
  }
}
