import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  String? _tokenDevice;

  String? get selectedNotificationData => _tokenDevice;

  void setNotificationData(String tokenDevice) {
    _tokenDevice = tokenDevice;
    notifyListeners();
  }
}
