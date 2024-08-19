import 'package:flutter/material.dart';
import 'package:paramedix/api/models/profile/favorite_model.dart';

class FavoriteProvider with ChangeNotifier{
  List<FavoriteItem>? _favoriteProvider;

  List<FavoriteItem>? get favoriteProviderData => _favoriteProvider;

  void setFavoriteData(List<FavoriteItem> newData) {
    _favoriteProvider = newData;
    notifyListeners();
  }
}
