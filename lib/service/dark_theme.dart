import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool _dark = false;

  ThemeNotifier(this._dark);

  ThemeMode getTheme() {
    return _dark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _dark = !_dark;
    notifyListeners();
  }
}
