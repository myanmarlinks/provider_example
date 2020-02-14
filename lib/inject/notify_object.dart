import 'package:flutter/material.dart';

class NotifyObject with ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
  }

}