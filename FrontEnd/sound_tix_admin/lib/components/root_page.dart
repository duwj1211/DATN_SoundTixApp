import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SoundTixRootPage extends StatefulWidget {
  final Widget child;
  const SoundTixRootPage({super.key, required this.child});

  @override
  State<SoundTixRootPage> createState() => _SoundTixRootPageState();
}

class _SoundTixRootPageState extends State<SoundTixRootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            const HeaderAdmin(),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

class HeaderAdmin extends StatefulWidget {
  const HeaderAdmin({super.key});

  @override
  State<HeaderAdmin> createState() => _HeaderAdminState();
}

class _HeaderAdminState extends State<HeaderAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {},
              child: const Icon(Icons.menu, size: 25),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.notifications_active_outlined, size: 25),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                child: VerticalDivider(thickness: 2),
              ),
              UserMenuHeaderAdmin(),
            ],
          ),
        ],
      ),
    );
  }
}

class UserMenuHeaderAdmin extends StatefulWidget {
  const UserMenuHeaderAdmin({super.key});

  @override
  State<UserMenuHeaderAdmin> createState() => _UserMenuHeaderAdminState();
}

class _UserMenuHeaderAdminState extends State<UserMenuHeaderAdmin> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            "images/avatar.jpg",
            height: 35,
            width: 35,
          ),
        ),
        const SizedBox(width: 15),
        const Text("Trần Văn Dự", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        PopupMenuButton(
          offset: const Offset(5, 45),
          tooltip: '',
          itemBuilder: (context) => [
            PopupMenuItem(
              child: SizedBox(
                width: 120,
                child: ListTile(
                  onTap: () {
                    context.go('/profile');
                  },
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  title: const Row(
                    children: [
                      Icon(Icons.account_circle_outlined, size: 20),
                      SizedBox(width: 10),
                      Text("Account", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuItem(
              child: SizedBox(
                width: 120,
                child: ListTile(
                  onTap: () {},
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
          child: const Icon(Icons.keyboard_arrow_down, size: 23),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
