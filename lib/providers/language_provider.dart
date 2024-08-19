import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isLanguageEnglish = true;

  bool get isLanguageEnglish => _isLanguageEnglish;

  void toggleLanguage() {
    _isLanguageEnglish = !_isLanguageEnglish;
    notifyListeners();
  }

  Locale getCurrentLocale() {
    return _isLanguageEnglish ? const Locale('en') : const Locale('km');
  }

  void setIsLanguageEnglish(bool isLanguageEnglish) {
    _isLanguageEnglish = isLanguageEnglish;
    notifyListeners();
  }
}
