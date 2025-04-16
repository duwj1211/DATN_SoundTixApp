import 'package:flutter/material.dart';

class DisplayDrawerModel extends ChangeNotifier {
  bool isDisplayed = true;

  void setIsDisplayed() {
    isDisplayed = !isDisplayed;
    notifyListeners();
  }
}
