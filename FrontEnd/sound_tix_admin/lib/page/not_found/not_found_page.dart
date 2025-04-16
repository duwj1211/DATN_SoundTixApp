import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/404_not_found.png"),
              const SizedBox(height: 20),
              const Text("Page Not Found", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const Text("Oops! The Page you requested was not found!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 30),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    context.go('/home-page');
                  });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DC275),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Back To Home",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
