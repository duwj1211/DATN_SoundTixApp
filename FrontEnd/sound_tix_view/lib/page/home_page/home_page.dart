import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/home_page/home/home.dart';
import 'package:sound_tix_view/page/home_page/my_order/my_order.dart';
import 'package:sound_tix_view/page/home_page/profile/profile.dart';

class HomePage extends StatefulWidget {
  final int index;
  const HomePage({super.key, required this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    currentPageIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: [
          const DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: DefaultHomePage(),
          ),
          SingleChildScrollView(
            child: MyTicketPage(
              user: "Nguyễn Phương Linh",
              callbackPageIndex: (newIndex) {
                setState(() {
                  currentPageIndex = newIndex;
                });
              },
            ),
          ),
          const SingleChildScrollView(
            child: ProfilePage(),
          ),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: changeThemeModel.isDark ? Colors.grey[600] : Colors.grey[400],
            backgroundColor: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                color: changeThemeModel.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home, color: changeThemeModel.isDark ? Colors.white : Colors.black), label: AppLocalizations.of(context).translate("Home")),
              NavigationDestination(icon: Icon(Icons.shopping_cart, color: changeThemeModel.isDark ? Colors.white : Colors.black), label: AppLocalizations.of(context).translate("My Order")),
              NavigationDestination(icon: Icon(Icons.person, color: changeThemeModel.isDark ? Colors.white : Colors.black), label: AppLocalizations.of(context).translate("Profile")),
            ],
          ),
        ),
      );
    });
  }
}
