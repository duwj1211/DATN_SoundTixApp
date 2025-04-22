import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/model/model.dart';

class DeleteAccountSuccessfulPage extends StatelessWidget {
  const DeleteAccountSuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Icon(Icons.sentiment_very_dissatisfied, size: 180, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context).translate("Your account has been successfully deleted."),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context).translate("Your account will be automatically logged out."),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          alignment: Alignment.center,
          height: 130,
          color: changeThemeModel.isDark ? const Color.fromARGB(255, 42, 42, 42) : Colors.white,
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Column(
            children: [
              SizedBox(
                height: 45,
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
                    decoration: BoxDecoration(color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(99)),
                    child: Text(AppLocalizations.of(context).translate("LOG IN"),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    context.go('/sign-up');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 230, 230, 230), borderRadius: BorderRadius.circular(99)),
                    child: Text(AppLocalizations.of(context).translate("SIGN UP"),
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
