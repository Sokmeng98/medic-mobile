import 'package:flutter/material.dart';
import 'package:paramedix/api/models/home/questionnaire_model.dart';

class QuestionnaireProvider with ChangeNotifier {
  QuestionnaireItem? _questionnaireData;

  QuestionnaireItem? get selectedQuestionnaireData => _questionnaireData;

  void setQuestionnaireData(QuestionnaireItem newData) {
    _questionnaireData = newData;
    notifyListeners();
  }
}
