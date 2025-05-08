import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

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
                context.go('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đăng xuất thành công.'),
                    duration: Duration(seconds: 1),
                  ),
                );
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
        child: Image.asset("images/avatar.jpg", height: 30, width: 30),
      ),
    );
  }
}
