import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class VerifiedScreen extends StatelessWidget {
  const VerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.asset("images/verified.png", width: 250, height: 250),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate("Your account has been verified successfully!"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
            const SizedBox(height: 35),
            Center(
              child: InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  context.go('/login');
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: const Color(0xFF2DC275),
                  ),
                  child: Text(AppLocalizations.of(context).translate("DONE"), style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
