import 'package:flutter/material.dart';
import 'package:paramedix/api/models/home/education_model.dart';

class ArticleProvider with ChangeNotifier {
  EducationItem? _articleData;

  EducationItem? get selectedArticleData => _articleData;

  void setArticleData(EducationItem newData) {
    _articleData = newData;
    notifyListeners();
  }
}
