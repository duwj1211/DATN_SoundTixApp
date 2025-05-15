import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/user.dart';

class RootOrganizerPage extends StatefulWidget {
  final String currentPage;
  final Widget child;
  const RootOrganizerPage({super.key, required this.currentPage, required this.child});

  @override
  State<RootOrganizerPage> createState() => _RootOrganizerPageState();
}

class _RootOrganizerPageState extends State<RootOrganizerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              tileColor: widget.currentPage == "My event" ? Colors.grey.shade300 : null,
              leading: const Icon(Icons.music_note_outlined),
              title: const Text("My event"),
              onTap: () {
                Navigator.pop(context);
                context.go('/organizer-center');
              },
            ),
            ListTile(
              tileColor: widget.currentPage == "Report management" ? Colors.grey.shade300 : null,
              leading: const Icon(Icons.folder),
              title: const Text("Report management"),
              onTap: () {
                Navigator.pop(context);
                context.go('/report-management');
              },
            ),
            ListTile(
              tileColor: widget.currentPage == "Profile" ? Colors.grey.shade300 : null,
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                context.go('/organizer-profile');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Center(
          child: Text(
            AppLocalizations.of(context).translate("Organizer center"),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2DC275),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: UserMenuHeaderWidget(),
          ),
        ],
      ),
      body: widget.child,
    );
  }
}

class UserMenuHeaderWidget extends StatefulWidget {
  const UserMenuHeaderWidget({super.key});

  @override
  State<UserMenuHeaderWidget> createState() => _UserMenuHeaderWidgetState();
}

class _UserMenuHeaderWidgetState extends State<UserMenuHeaderWidget> {
  User? user;
  String pathAvatar = "avatar.jpg";

  @override
  void initState() {
    super.initState();
    getInitPage();
  }

  getInitPage() async {
    await getDetailUser();
    return 0;
  }

  getDetailUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (mounted) {
      var response = await httpGet(context, "http://localhost:8080/user/$userId");
      setState(() {
        user = User.fromMap(response["body"]);
        pathAvatar = user!.avatar;
      });
    }
  }

  logout() async {
    try {
      await httpPost(context, "http://localhost:8080/api/auth/logout", {});

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('jwtToken');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng xuất thành công.'),
            duration: Duration(seconds: 1),
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi, vui lòng thử lại'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(5, 45),
      tooltip: '',
      itemBuilder: (context) => [
        PopupMenuItem(
          child: SizedBox(
            width: 120,
            child: ListTile(
              onTap: () {
                showConfirmDialog();
              },
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              title: const Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 10),
                  Text("Sign out", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ],
      child: ClipOval(
        child: Image.asset("images/$pathAvatar", height: 30, width: 30),
      ),
    );
  }

  showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.exit_to_app, size: 20),
                            const SizedBox(width: 5),
                            Text(AppLocalizations.of(context).translate("Log out"),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(AppLocalizations.of(context).translate("Do you want to log out of SoundTix?"),
                          style: const TextStyle(fontSize: 14, color: Colors.black)),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(AppLocalizations.of(context).translate("Cancel"),
                                  style: const TextStyle(color: Color(0xFF2DC275), fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              logout();
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DC275),
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child:
                                  Text(AppLocalizations.of(context).translate("Log out"), style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
