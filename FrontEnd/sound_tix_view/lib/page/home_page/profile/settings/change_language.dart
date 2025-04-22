import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class ChangeLanguageWidget extends StatefulWidget {
  const ChangeLanguageWidget({super.key});

  @override
  State<ChangeLanguageWidget> createState() => _ChangeLanguageWidgetState();
}

class _ChangeLanguageWidgetState extends State<ChangeLanguageWidget> {
  String selectedLanguage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeProvider = Provider.of<LocaleProvider>(context);
    selectedLanguage = localeProvider.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                color: const Color(0xFF2DC275),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    const ButtonBack(),
                    const SizedBox(width: 20),
                    Text(AppLocalizations.of(context).translate("Change language"),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedLanguage = "en";
                  });
                },
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate("English"),
                      style: TextStyle(
                          color: selectedLanguage == "en"
                              ? const Color(0xFF2DC275)
                              : (selectedLanguage != "en" && changeThemeModel.isDark)
                                  ? Colors.white
                                  : Colors.black)),
                  trailing: selectedLanguage == "en" ? const Icon(Icons.check_circle, color: Colors.green, size: 20) : null,
                ),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedLanguage = "vi";
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color.fromRGBO(216, 218, 229, 1)),
                      bottom: BorderSide(color: Color.fromRGBO(216, 218, 229, 1)),
                    ),
                  ),
                  child: ListTile(
                    title: Text(AppLocalizations.of(context).translate("Vietnamese"),
                        style: TextStyle(
                            color: (selectedLanguage == "vi")
                                ? const Color(0xFF2DC275)
                                : (selectedLanguage != "vi" && changeThemeModel.isDark)
                                    ? Colors.white
                                    : Colors.black)),
                    trailing: selectedLanguage == "vi" ? const Icon(Icons.check_circle, color: Colors.green, size: 20) : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          alignment: Alignment.center,
          height: 60,
          color: changeThemeModel.isDark ? const Color.fromARGB(255, 42, 42, 42) : Colors.white,
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Provider.of<LocaleProvider>(context, listen: false).setLocale(selectedLanguage);
              // Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(99)),
              child: Text(AppLocalizations.of(context).translate("Save change"),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
            ),
          ),
        ),
      );
    });
  }
}
