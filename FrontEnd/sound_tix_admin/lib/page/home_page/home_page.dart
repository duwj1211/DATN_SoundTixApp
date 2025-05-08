import 'package:flutter/material.dart';
import 'package:sound_tix_admin/components/root_page.dart';
import 'package:sound_tix_admin/page/artist_management/artist_management.dart';
import 'package:sound_tix_admin/page/order_tracker/order_tracker.dart';
import 'package:sound_tix_admin/page/dashboard/dashboard.dart';
import 'package:sound_tix_admin/page/event_management/event_management.dart';
import 'package:sound_tix_admin/page/ticket_management/ticket_management.dart';
import 'package:sound_tix_admin/page/user_management/user_management.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tabBarList = ["Dashboard", "User management", "Event management", "Ticket management", "Artist Management", "Order Tracker"];

  final PageController _pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(child: drawerMenu(context)),
            Expanded(
              flex: 5,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SoundTixRootPage(child: DashboardWidget()),
                  SoundTixRootPage(child: UserManagementWidget()),
                  SoundTixRootPage(child: EventManagementWidget()),
                  SoundTixRootPage(child: TicketManagementWidget()),
                  SoundTixRootPage(child: ArtistManagementWidget()),
                  SoundTixRootPage(child: OrderTrackerWidget()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container drawerMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: Center(child: Image.asset("images/soundtix_logo.png", height: 150)),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.separated(
                itemCount: tabBarList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        _pageController.jumpToPage(index);
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selectedIndex == index
                            ? LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.blue.shade100,
                                  Colors.grey.shade100,
                                ],
                              )
                            : null,
                        border: selectedIndex == index ? const Border(left: BorderSide(color: Colors.blue, width: 5)) : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          tabBarList[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedIndex == index ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
