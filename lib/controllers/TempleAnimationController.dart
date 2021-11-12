// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TempleAnimationController extends ChangeNotifier {
  bool isDrawerOpen = false;

  void updateDrawerOpen() {
    isDrawerOpen = !isDrawerOpen;
    notifyListeners();
  }
}
