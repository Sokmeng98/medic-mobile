import 'package:flutter/material.dart';

class ForgetPasswordProvider with ChangeNotifier {
  String? _phoneNumberProvider;

  String? get phoneNumberProviderData => _phoneNumberProvider;

  void setForgetPasswordData(String phoneNumber) {
    _phoneNumberProvider = phoneNumber;
    notifyListeners();
  }
}
