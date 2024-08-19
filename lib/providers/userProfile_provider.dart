import 'package:flutter/material.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  ProfileModel? _profileProvider;

  ProfileModel? get profileProviderData => _profileProvider;

  void setProfileData(ProfileModel newData) {
    _profileProvider = newData;
    notifyListeners();
  }
}
