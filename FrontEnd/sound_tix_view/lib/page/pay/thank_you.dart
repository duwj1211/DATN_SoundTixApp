import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset("images/thank_you.png"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("Thanks you"),
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).translate("Your payment has been successful."),
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 30),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  context.go('/my-tickets');
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DC275),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate("View your tickets"),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
