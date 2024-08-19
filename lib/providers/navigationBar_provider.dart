import 'package:flutter/material.dart';

class NavigationBarProvider with ChangeNotifier {
  bool _showNavigationBar = true;

  bool get showNavigationBar => _showNavigationBar;

  void toggleNavigationBar() {
    _showNavigationBar = !_showNavigationBar;
    notifyListeners();
  }
}
