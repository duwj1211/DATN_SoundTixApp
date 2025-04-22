import 'package:flutter/material.dart';

class ChangeThemeModel extends ChangeNotifier {
  bool isDark = false;

  void setBrightness(value) {
    isDark = value;
    notifyListeners();
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}