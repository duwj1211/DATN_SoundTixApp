import 'package:flutter/material.dart';

Route newCreateRoute(Widget widget) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              width: MediaQuery.of(context).size.width / 8,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              right: 0,
              width: MediaQuery.of(context).size.width * 7 / 8,
              height: MediaQuery.of(context).size.height,
              child: Material(
                color: Colors.white,
                elevation: 8,
                child: widget,
              ),
            ),
          ],
        ),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.linear;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
