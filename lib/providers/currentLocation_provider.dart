import 'package:flutter/material.dart';

class CurrentLocationProvider with ChangeNotifier {
  double? _latitudeValueProvider;
  double? _longitudeValueProvider;

  double? get latitudeValueProviderData => _latitudeValueProvider;
  double? get longitudeValueProviderData => _longitudeValueProvider;

  void setLatitudeValueData(double latitudeValue) {
    _latitudeValueProvider = latitudeValue;
    notifyListeners();
  }

  void setLongitudeValueData(double longitudeValue) {
    _longitudeValueProvider = longitudeValue;
    notifyListeners();
  }
}
