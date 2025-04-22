import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class ChangeThemeWidget extends StatefulWidget {
  const ChangeThemeWidget({super.key});

  @override
  State<ChangeThemeWidget> createState() => _ChangeThemeWidgetState();
}

class _ChangeThemeWidgetState extends State<ChangeThemeWidget> {
  // Timer? _debounceTimer;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeThemeModel = Provider.of<ChangeThemeModel>(context, listen: false);
      setState(() {
        isDark = changeThemeModel.isDark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              color: const Color(0xFF2DC275),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: [
                  const ButtonBack(),
                  const SizedBox(width: 20),
                  Text(AppLocalizations.of(context).translate("Change theme color"),
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
                  isDark = false;
                });
              },
              child: ListTile(
                title: Text(AppLocalizations.of(context).translate("White"),
                    style: TextStyle(
                        color: (isDark && changeThemeModel.isDark)
                            ? Colors.white
                            : (isDark && !changeThemeModel.isDark)
                                ? Colors.black
                                : const Color(0xFF2DC275))),
                trailing: isDark ? null : const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  isDark = true;
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
                  title: Text(AppLocalizations.of(context).translate("Black"),
                      style: TextStyle(
                          color: (!isDark && changeThemeModel.isDark)
                              ? Colors.white
                              : (!isDark && !changeThemeModel.isDark)
                                  ? Colors.black
                                  : const Color(0xFF2DC275))),
                  trailing: isDark ? const Icon(Icons.check_circle, color: Colors.green, size: 20) : null,
                ),
              ),
            ),
          ],
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
              changeThemeModel.setBrightness(isDark);
              // if (_debounceTimer?.isActive ?? false) {
              //   _debounceTimer?.cancel();
              // }

              // _debounceTimer = Timer(const Duration(milliseconds: 300), () {
              //   Navigator.pop(context);
              // });
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
