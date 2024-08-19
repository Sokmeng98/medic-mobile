import 'package:flutter/material.dart';

class NearbyFacilityProvider with ChangeNotifier {
  int? _serviceValueProvider;
  int? _locationValueProvider;

  int? get serviceValueProviderData => _serviceValueProvider;
  int? get locationValueProviderData => _locationValueProvider;

  void setServiceValueData(int serviceValue) {
    _serviceValueProvider = serviceValue;
    notifyListeners();
  }

  void setLocationValueData(int locationValue) {
    _locationValueProvider = locationValue;
    notifyListeners();
  }

  void setServiceNullValueData(Null serviceNullValue) {
    _serviceValueProvider = serviceNullValue;
    notifyListeners();
  }

  void setLocationNullValueData(Null locationNullValue) {
    _locationValueProvider = locationNullValue;
    notifyListeners();
  }
}
