import 'package:flutter/material.dart';

class HeaderTitle extends StatefulWidget {
  const HeaderTitle({super.key});

  @override
  State<HeaderTitle> createState() => _HeaderTitleState();
}

class _HeaderTitleState extends State<HeaderTitle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {},
      child: const Icon(Icons.menu),
    );
  }
}
