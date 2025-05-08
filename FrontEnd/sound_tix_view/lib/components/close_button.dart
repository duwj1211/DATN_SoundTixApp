import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class ButtonBack extends StatelessWidget {
  final bool? isPopScreen;
  const ButtonBack({super.key, this.isPopScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration:
          BoxDecoration(color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 0.7)),
      child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (isPopScreen!) {
              Navigator.pop(context);
            } else {
              final Map extra = (GoRouterState.of(context).extra ?? {}) as Map;
              if (extra['oldUrl'] != null) {
                context.go(extra['oldUrl']);
              } else {
                Navigator.pop(context);
              }
            }
          },
          child: const Icon(Icons.arrow_back, size: 20, color: Colors.white)),
    );
  }
}

class ButtonShare extends StatelessWidget {
  const ButtonShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration:
          BoxDecoration(color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 0.5)),
      child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {},
          child: const Icon(
            Icons.share,
            size: 20,
            color: Colors.white,
          )),
    );
  }
}

class ButtonSave extends StatelessWidget {
  final Function onPressed;
  const ButtonSave({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: ElevatedButton(onPressed: () {}, child: Text(AppLocalizations.of(context).translate("OK"), style: const TextStyle(color: Colors.white))),
    );
  }
}
